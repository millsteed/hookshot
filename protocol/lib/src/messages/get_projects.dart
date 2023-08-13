import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hookshot_protocol/hookshot_protocol.dart';

part 'get_projects.freezed.dart';
part 'get_projects.g.dart';

@freezed
class GetProjectsResponse with _$GetProjectsResponse {
  const factory GetProjectsResponse({
    required List<Project> projects,
  }) = _GetProjectsResponse;

  factory GetProjectsResponse.fromJson(Json json) =>
      _$GetProjectsResponseFromJson(json);
}
