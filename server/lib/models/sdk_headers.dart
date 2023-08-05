import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hookshot_protocol/hookshot_protocol.dart';

part 'sdk_headers.freezed.dart';
part 'sdk_headers.g.dart';

@freezed
class SdkHeaders with _$SdkHeaders {
  const factory SdkHeaders({
    required String project,
    required String secret,
    required String device,
  }) = _SdkHeaders;

  factory SdkHeaders.fromJson(Json json) => _$SdkHeadersFromJson(json);
}
