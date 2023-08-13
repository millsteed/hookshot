import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hookshot_protocol/hookshot_protocol.dart';

part 'attachment.freezed.dart';
part 'attachment.g.dart';

@freezed
class Attachment with _$Attachment {
  const factory Attachment({
    required String id,
    required String feedbackId,
    required String name,
  }) = _Attachment;

  factory Attachment.fromJson(Json json) => _$AttachmentFromJson(json);
}
