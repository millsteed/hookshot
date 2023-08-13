import 'package:hookshot_client/hookshot_client.dart';

sealed class ProjectsState {}

class ProjectsInitial extends ProjectsState {}

class ProjectsLoading extends ProjectsState {}

class ProjectsSuccess extends ProjectsState {
  ProjectsSuccess(this.projects);

  final List<Project> projects;
}

class ProjectsFailure extends ProjectsState {
  ProjectsFailure(this.error);

  final String error;
}
