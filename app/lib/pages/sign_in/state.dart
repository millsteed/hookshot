sealed class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  SignInSuccess();
}

class SignInFailure extends SignInState {
  SignInFailure(this.error);

  final String error;
}
