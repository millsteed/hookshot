import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookshot_app/pages/create_project/event.dart';
import 'package:hookshot_app/pages/create_project/state.dart';
import 'package:hookshot_app/repositories/project_repository.dart';
import 'package:hookshot_client/hookshot_client.dart';

class CreateProjectBloc extends Bloc<CreateProjectEvent, CreateProjectState> {
  CreateProjectBloc(this.projectRepository) : super(CreateProjectInitial()) {
    on<CreateProjectEvent>(
      (event, emit) => switch (event) {
        CreateProjectStarted() => _handleStarted(event, emit),
        CreateProjectSubmitted() => _handleSubmitted(event, emit),
      },
    );
  }

  final ProjectRepository projectRepository;

  Future<void> _handleStarted(
    CreateProjectStarted event,
    Emitter<CreateProjectState> emit,
  ) async {}

  Future<void> _handleSubmitted(
    CreateProjectSubmitted event,
    Emitter<CreateProjectState> emit,
  ) async {
    emit(CreateProjectLoading());
    try {
      final response = await projectRepository.createProject(name: event.name);
      emit(CreateProjectSuccess(response.projectId));
    } on HookshotClientException catch (e) {
      emit(CreateProjectFailure(e.message));
    } on Exception {
      emit(CreateProjectFailure('Something unexpected happened.'));
    }
  }
}
