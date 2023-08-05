import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hookshot_protocol/hookshot_protocol.dart';

part 'sdk_promoter_score.freezed.dart';
part 'sdk_promoter_score.g.dart';

@freezed
class SdkPromoterScore with _$SdkPromoterScore {
  const factory SdkPromoterScore({
    required String appLocale,
    String? buildCommit,
    String? buildNumber,
    String? buildVersion,
    required String deviceId,
    String? message,
    String? platformLocale,
    String? platformOS,
    String? platformOSVersion,
    String? platformUserAgent,
    required String question,
    int? score,
    required int sdkVersion,
    String? userEmail,
    String? userId,
  }) = _SdkPromoterScore;

  factory SdkPromoterScore.fromJson(Json json) =>
      _$SdkPromoterScoreFromJson(json);
}
