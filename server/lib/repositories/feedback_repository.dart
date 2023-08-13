import 'dart:io';

import 'package:hookshot_protocol/hookshot_protocol.dart';
import 'package:hookshot_server/models/multipart.dart';
import 'package:hookshot_server/models/sdk_feedback.dart';
import 'package:hookshot_server/utils/uuid.dart';
import 'package:postgres/postgres.dart';

class FeedbackRepository {
  FeedbackRepository(this.database, this.storagePath);

  final PostgreSQLConnection database;
  final String storagePath;

  Future<List<Feedback>> getFeedback({String? projectId}) async {
    final filter = [
      if (projectId != null) 'project_id = @project_id',
      'feedback.deleted_at IS NULL',
    ].join(' AND ');
    final results = await database.mappedResultsQuery(
      'SELECT feedback.id, project_id, data, attachments.id, feedback_id, name '
      'FROM feedback '
      'LEFT JOIN attachments ON feedback_id = feedback.id '
      'WHERE $filter '
      'ORDER BY feedback.created_at DESC',
      substitutionValues: {'project_id': projectId},
    );
    final attachments = results.map((e) => e['attachments']!).map((e) {
      final id = e['id'] as String?;
      final feedbackId = e['feedback_id'] as String?;
      final name = e['name'] as String?;
      if (id == null || feedbackId == null || name == null) {
        return null;
      }
      return Attachment(id: id, feedbackId: feedbackId, name: name);
    }).whereType<Attachment>();
    return results
        .map((e) => e['feedback']!)
        .map((e) {
          final id = e['id'] as String;
          final projectId = e['project_id'] as String;
          final data = SdkFeedback.fromJson(e['data'] as Json);
          final attachmentIds = data.attachments?.map((e) => e.id);
          final feedbackAttachments = attachmentIds != null
              ? attachments
                  .where((attachment) => attachmentIds.contains(attachment.id))
                  .toList()
              : null;
          return Feedback(
            id: id,
            projectId: projectId,
            email: data.userEmail,
            message: data.message,
            attachments: feedbackAttachments,
          );
        })
        .toSet()
        .toList();
  }

  Future<String> createAttachment(String type, MultipartFile file) async {
    final id = uuid.v4();
    final filename = file.filename ?? uuid.v4();
    final extension = file.contentType.split('/').last;
    final name = '$filename.$extension';
    File('$storagePath/$id/$name')
      ..createSync(recursive: true)
      ..writeAsBytesSync(file.data);
    await _executeCreateAttachment(database, id, name, type);
    return id;
  }

  Future<void> _executeCreateAttachment(
    PostgreSQLExecutionContext database,
    String id,
    String name,
    String type,
  ) async {
    final now = DateTime.now();
    await database.execute(
      'INSERT INTO attachments (id, created_at, updated_at, name, type) '
      'VALUES (@id, @created_at, @updated_at, @name, @type)',
      substitutionValues: {
        'id': id,
        'created_at': now,
        'updated_at': now,
        'name': name,
        'type': type,
      },
    );
  }

  Future<String> createFeedback(String projectId, SdkFeedback feedback) async {
    final id = uuid.v4();
    await database.transaction((database) async {
      await _executeCreateFeedback(database, id, projectId, feedback);
      final attachments = feedback.attachments;
      if (attachments != null) {
        for (final attachment in attachments) {
          await _executeUpdateAttachmentFeedbackId(database, attachment.id, id);
        }
      }
    });
    return id;
  }

  Future<void> _executeCreateFeedback(
    PostgreSQLExecutionContext database,
    String id,
    String projectId,
    SdkFeedback feedback,
  ) async {
    final now = DateTime.now();
    await database.execute(
      'INSERT INTO feedback (id, created_at, updated_at, project_id, data) '
      'VALUES (@id, @created_at, @updated_at, @project_id, @data)',
      substitutionValues: {
        'id': id,
        'created_at': now,
        'updated_at': now,
        'project_id': projectId,
        'data': feedback.toJson(),
      },
    );
  }

  Future<void> _executeUpdateAttachmentFeedbackId(
    PostgreSQLExecutionContext database,
    String id,
    String feedbackId,
  ) async {
    final now = DateTime.now();
    await database.execute(
      'UPDATE attachments '
      'SET updated_at = @updated_at, feedback_id = @feedback_id '
      'WHERE id = @id',
      substitutionValues: {
        'updated_at': now,
        'feedback_id': feedbackId,
        'id': id,
      },
    );
  }
}
