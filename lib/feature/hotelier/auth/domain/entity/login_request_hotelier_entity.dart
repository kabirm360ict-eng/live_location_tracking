import 'package:equatable/equatable.dart';

class LoginRequestHotelierEntity extends Equatable {
  final dynamic email;
  final dynamic password;

  const LoginRequestHotelierEntity({this.email, this.password});

  @override
  List<Object?> get props => [email, password];
}
