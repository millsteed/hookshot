import 'package:hookshot_client/hookshot_client.dart';

class ProjectRepository {
  ProjectRepository(this.hookshotClient);

  final HookshotClient hookshotClient;

  Future<GetProjectsResponse> getProjects() => hookshotClient.getProjects();

  Future<CreateProjectResponse> createProject({required String name}) =>
      hookshotClient.createProject(name: name);
}
