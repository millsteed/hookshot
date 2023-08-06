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

  Future<List<Feedback>> getFeedback() async {
    final results = await database.mappedResultsQuery(
      'SELECT feedback.id, data, attachments.id, name '
      'FROM feedback '
      'LEFT JOIN attachments ON feedback_id = feedback.id '
      'WHERE feedback.deleted_at IS NULL '
      'ORDER BY feedback.created_at DESC',
    );
    final attachments = Map.fromEntries(
      results
          .map((e) => e['attachments']!)
          .where((e) => e['id'] != null && e['name'] != null)
          .map((e) => MapEntry(e['id'] as String, e['name'] as String)),
    );
    final feedback = Map.fromEntries(
      results
          .map((e) => e['feedback']!)
          .map((e) => MapEntry(e['id'] as String, e['data'] as Json))
          .map((e) => MapEntry(e.key, SdkFeedback.fromJson(e.value))),
    );
    return feedback.entries
        .map(
          (e) => Feedback(
            id: e.key,
            email: e.value.userEmail,
            message: e.value.message,
            attachments: e.value.attachments
                ?.map((e) => Attachment(id: e.id, name: attachments[e.id]!))
                .toList(),
          ),
        )
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

  Future<String> createFeedback(SdkFeedback feedback) async {
    final id = uuid.v4();
    await database.transaction((database) async {
      await _executeCreateFeedback(database, id, feedback);
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
    SdkFeedback feedback,
  ) async {
    final now = DateTime.now();
    await database.execute(
      'INSERT INTO feedback (id, created_at, updated_at, data) '
      'VALUES (@id, @created_at, @updated_at, @data)',
      substitutionValues: {
        'id': id,
        'created_at': now,
        'updated_at': now,
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
