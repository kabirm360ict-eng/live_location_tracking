import 'package:equatable/equatable.dart';

class LoginRequestJobEntity extends Equatable {
  final dynamic email;
  final dynamic password;

  const LoginRequestJobEntity({this.email, this.password});

  @override
  List<Object?> get props => [email, password];
}
