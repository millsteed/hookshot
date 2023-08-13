import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hookshot_protocol/hookshot_protocol.dart';

part 'promoter_score.freezed.dart';
part 'promoter_score.g.dart';

@freezed
class PromoterScore with _$PromoterScore {
  const factory PromoterScore({
    required String id,
    required String projectId,
    String? email,
    required String question,
    String? message,
    int? score,
  }) = _PromoterScore;

  factory PromoterScore.fromJson(Json json) => _$PromoterScoreFromJson(json);
}
