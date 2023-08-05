import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hookshot_protocol/hookshot_protocol.dart';

part 'feedback.freezed.dart';
part 'feedback.g.dart';

@freezed
class Feedback with _$Feedback {
  const factory Feedback({
    required String id,
    String? email,
    required String message,
    List<Attachment>? attachments,
  }) = _Feedback;

  factory Feedback.fromJson(Json json) => _$FeedbackFromJson(json);
}
