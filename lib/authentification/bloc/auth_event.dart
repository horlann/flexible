part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStart extends AuthEvent {}

class GoToSignIn extends AuthEvent {}

class GoToRegistration extends AuthEvent {}

class SignInByPhone extends AuthEvent {
  final String phone;

  SignInByPhone({
    required this.phone,
  });

  @override
  List<Object> get props => [phone];
}

class ResendCode extends AuthEvent {}

class VerifyCode extends AuthEvent {
  final String smsCode;

  VerifyCode({
    required this.smsCode,
  });

  @override
  List<Object> get props => [smsCode];
}

class SignOut extends AuthEvent {}

class CreateAccount extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  CreateAccount({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class AddData extends AuthEvent {
  final String name;
  final String email;
  AddData({
    required this.name,
    required this.email,
  });
}
