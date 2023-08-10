import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hookshot_protocol/hookshot_protocol.dart';

part 'get_promoter_scores.freezed.dart';
part 'get_promoter_scores.g.dart';

@freezed
class GetPromoterScoresResponse with _$GetPromoterScoresResponse {
  const factory GetPromoterScoresResponse({
    required List<PromoterScore> promoterScores,
  }) = _GetAllPromoterScoresResponse;

  factory GetPromoterScoresResponse.fromJson(Json json) =>
      _$GetPromoterScoresResponseFromJson(json);
}
