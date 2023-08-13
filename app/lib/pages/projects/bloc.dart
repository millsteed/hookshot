import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookshot_app/pages/projects/event.dart';
import 'package:hookshot_app/pages/projects/state.dart';
import 'package:hookshot_app/repositories/project_repository.dart';
import 'package:hookshot_client/hookshot_client.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc(this.projectsRepository) : super(ProjectsInitial()) {
    on<ProjectsEvent>(
      (event, emit) => switch (event) {
        ProjectsStarted() => _handleStarted(event, emit),
      },
    );
  }

  final ProjectRepository projectsRepository;

  Future<void> _handleStarted(
    ProjectsStarted event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(ProjectsLoading());
    try {
      final response = await projectsRepository.getProjects();
      final projects = response.projects;
      emit(ProjectsSuccess(projects));
    } on HookshotClientException catch (e) {
      emit(ProjectsFailure(e.message));
    } on Exception {
      emit(ProjectsFailure('Something unexpected happened.'));
    }
  }
}
