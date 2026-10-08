abstract class Failure {
  final String message;
  Failure(this.message);
}

class ApiFailure extends Failure {
  ApiFailure(super.message);
}
