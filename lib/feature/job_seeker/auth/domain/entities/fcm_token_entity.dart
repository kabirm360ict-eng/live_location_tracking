import 'package:equatable/equatable.dart';

class FcmTokenEntity extends Equatable {
  final dynamic fcmToken;

  const FcmTokenEntity({this.fcmToken});

  @override
  List<Object?> get props => [fcmToken];
}
