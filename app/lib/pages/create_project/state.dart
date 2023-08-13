sealed class CreateProjectState {}

class CreateProjectInitial extends CreateProjectState {}

class CreateProjectLoading extends CreateProjectState {}

class CreateProjectSuccess extends CreateProjectState {
  CreateProjectSuccess(this.projectId);

  final String projectId;
}

class CreateProjectFailure extends CreateProjectState {
  CreateProjectFailure(this.error);

  final String error;
}
