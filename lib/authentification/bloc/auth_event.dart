part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStart extends AuthEvent {}

class SendCode extends AuthEvent {
  final String phone;

  SendCode({
    required this.phone,
  });

  @override
  List<Object> get props => [phone];
}

class VerifyCode extends AuthEvent {
  final String smsCode;

  VerifyCode({
    required this.smsCode,
  });

  @override
  List<Object> get props => [smsCode];
}

class SignOut extends AuthEvent {}
