import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hookshot_protocol/hookshot_protocol.dart';

part 'sign_up.freezed.dart';
part 'sign_up.g.dart';

@freezed
class SignUpRequest with _$SignUpRequest {
  const factory SignUpRequest({
    required String name,
    required String email,
    required String password,
  }) = _SignUpRequest;

  factory SignUpRequest.fromJson(Json json) => _$SignUpRequestFromJson(json);
}

@freezed
class SignUpResponse with _$SignUpResponse {
  const factory SignUpResponse({
    required User user,
    required String sessionToken,
  }) = _SignUpResponse;

  factory SignUpResponse.fromJson(Json json) => _$SignUpResponseFromJson(json);
}
