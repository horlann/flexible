part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStart extends AuthEvent {}

class GoToSignIn extends AuthEvent {}

class GoToRegistration extends AuthEvent {}

class CloseCodeVerification extends AuthEvent {}

class SignInByPhone extends AuthEvent {
  final String phone;

  SignInByPhone({
    required this.phone,
  });

  @override
  List<Object> get props => [phone];
}

class ResendCode extends AuthEvent {
  final String number;
  ResendCode({
    required this.number,
  });
}

class VerifyCode extends AuthEvent {
  final String smsCode;
  final String number;

  VerifyCode({
    required this.smsCode,
    required this.number,
  });

  @override
  List<Object> get props => [smsCode];
}

class SignOut extends AuthEvent {}

class CreateAccount extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final Uint8List? photo;
  CreateAccount({
    required this.name,
    required this.email,
    required this.phone,
    this.photo,
  });
}

class AddData extends AuthEvent {
  final String name;
  final String email;
  final Uint8List? photo;
  AddData({
    required this.name,
    required this.email,
    this.photo,
  });

  get signPhoneNumber => null;
}
