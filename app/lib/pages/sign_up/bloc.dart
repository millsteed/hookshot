import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookshot_app/pages/sign_up/event.dart';
import 'package:hookshot_app/pages/sign_up/state.dart';
import 'package:hookshot_app/repositories/account_repository.dart';
import 'package:hookshot_client/hookshot_client.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(this.accountRepository) : super(SignUpInitial()) {
    on<SignUpEvent>(
      (event, emit) => switch (event) {
        SignUpStarted() => _handleStarted(event, emit),
        SignUpSubmitted() => _handleSubmitted(event, emit),
      },
    );
  }
  final AccountRepository accountRepository;

  Future<void> _handleStarted(
    SignUpStarted event,
    Emitter<SignUpState> emit,
  ) async {}

  Future<void> _handleSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(SignUpLoading());
    try {
      await accountRepository.signUp(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      emit(SignUpSuccess());
    } on HookshotClientException catch (e) {
      emit(SignUpFailure(e.message));
    } on Exception {
      emit(SignUpFailure('Something unexpected happened.'));
    }
  }
}
