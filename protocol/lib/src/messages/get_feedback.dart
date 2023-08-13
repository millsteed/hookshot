import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hookshot_protocol/hookshot_protocol.dart';

part 'get_feedback.freezed.dart';
part 'get_feedback.g.dart';

@freezed
class GetFeedbackResponse with _$GetFeedbackResponse {
  const factory GetFeedbackResponse({
    required List<Feedback> feedback,
  }) = _GetFeedbackResponse;

  factory GetFeedbackResponse.fromJson(Json json) =>
      _$GetFeedbackResponseFromJson(json);
}
