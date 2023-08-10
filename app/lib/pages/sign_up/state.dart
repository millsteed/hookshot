sealed class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  SignUpSuccess();
}

class SignUpFailure extends SignUpState {
  SignUpFailure(this.error);

  final String error;
}
