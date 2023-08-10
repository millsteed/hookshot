sealed class SignUpEvent {}

class SignUpStarted extends SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  SignUpSubmitted(this.name, this.email, this.password);

  final String name;
  final String email;
  final String password;
}
