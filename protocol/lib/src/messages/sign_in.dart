import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hookshot_protocol/hookshot_protocol.dart';

part 'sign_in.freezed.dart';
part 'sign_in.g.dart';

@freezed
class SignInRequest with _$SignInRequest {
  const factory SignInRequest({
    required String email,
    required String password,
  }) = _SignInRequest;

  factory SignInRequest.fromJson(Json json) => _$SignInRequestFromJson(json);
}

@freezed
class SignInResponse with _$SignInResponse {
  const factory SignInResponse({
    required User user,
    required String sessionToken,
  }) = _SignInResponse;

  factory SignInResponse.fromJson(Json json) => _$SignInResponseFromJson(json);
}
