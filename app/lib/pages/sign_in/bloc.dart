import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookshot_app/pages/sign_in/event.dart';
import 'package:hookshot_app/pages/sign_in/state.dart';
import 'package:hookshot_app/repositories/account_repository.dart';
import 'package:hookshot_client/hookshot_client.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc(this.accountRepository) : super(SignInInitial()) {
    on<SignInEvent>(
      (event, emit) => switch (event) {
        SignInStarted() => _handleStarted(event, emit),
        SignInSubmitted() => _handleSubmitted(event, emit),
      },
    );
  }
  final AccountRepository accountRepository;

  Future<void> _handleStarted(
    SignInStarted event,
    Emitter<SignInState> emit,
  ) async {}

  Future<void> _handleSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInLoading());
    try {
      await accountRepository.signIn(
        email: event.email,
        password: event.password,
      );
      emit(SignInSuccess());
    } on HookshotClientException catch (e) {
      emit(SignInFailure(e.message));
    } on Exception {
      emit(SignInFailure('Something unexpected happened.'));
    }
  }
}
