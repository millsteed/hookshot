import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hookshot_protocol/hookshot_protocol.dart';

part 'sdk_attachment.freezed.dart';
part 'sdk_attachment.g.dart';

@freezed
class SdkAttachment with _$SdkAttachment {
  const factory SdkAttachment({
    required String id,
  }) = _SdkAttachment;

  factory SdkAttachment.fromJson(Json json) => _$SdkAttachmentFromJson(json);
}
