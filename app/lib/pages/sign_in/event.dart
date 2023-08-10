sealed class SignInEvent {}

class SignInStarted extends SignInEvent {}

class SignInSubmitted extends SignInEvent {
  SignInSubmitted(this.email, this.password);

  final String email;
  final String password;
}
