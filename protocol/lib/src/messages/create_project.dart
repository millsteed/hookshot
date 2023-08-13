import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hookshot_protocol/hookshot_protocol.dart';

part 'create_project.freezed.dart';
part 'create_project.g.dart';

@freezed
class CreateProjectRequest with _$CreateProjectRequest {
  const factory CreateProjectRequest({
    required String name,
  }) = _CreateProjectRequest;

  factory CreateProjectRequest.fromJson(Json json) =>
      _$CreateProjectRequestFromJson(json);
}

@freezed
class CreateProjectResponse with _$CreateProjectResponse {
  const factory CreateProjectResponse({
    required String projectId,
  }) = _CreateProjectResponse;

  factory CreateProjectResponse.fromJson(Json json) =>
      _$CreateProjectResponseFromJson(json);
}
