import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hookshot_protocol/hookshot_protocol.dart';
import 'package:hookshot_server/models/sdk_attachment.dart';

part 'sdk_feedback.freezed.dart';
part 'sdk_feedback.g.dart';

@freezed
class SdkFeedback with _$SdkFeedback {
  const factory SdkFeedback({
    required String appLocale,
    List<SdkAttachment>? attachments,
    String? buildCommit,
    String? buildNumber,
    String? buildVersion,
    required String compilationMode,
    Map<String, dynamic>? customMetaData,
    required String deviceId,
    List<String>? labels,
    required String message,
    required List<double> physicalGeometry,
    required String platformBrightness,
    String? platformDartVersion,
    required List<double> platformGestureInsets,
    required String platformLocale,
    String? platformOS,
    String? platformOSVersion,
    required List<String> platformSupportedLocales,
    String? platformUserAgent,
    required int sdkVersion,
    String? userEmail,
    String? userId,
    required List<double> windowInsets,
    required List<double> windowPadding,
    required double windowPixelRatio,
    required List<double> windowSize,
    required double windowTextScaleFactor,
  }) = _SdkFeedback;

  factory SdkFeedback.fromJson(Json json) => _$SdkFeedbackFromJson(json);
}
