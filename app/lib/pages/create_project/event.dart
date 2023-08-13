sealed class CreateProjectEvent {}

class CreateProjectStarted extends CreateProjectEvent {}

class CreateProjectSubmitted extends CreateProjectEvent {
  CreateProjectSubmitted(this.name);

  final String name;
}
