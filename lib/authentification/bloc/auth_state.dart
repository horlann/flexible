part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final bool isBusy;
  final String error;
  final String message;
  const AuthState({isBusy = false, error = '', message = ''})
      : this.isBusy = isBusy ?? false,
        this.error = error ?? '',
        this.message = message ?? '';

  @override
  List<Object> get props => [isBusy, error];
}

class AuthInitial extends AuthState {}

class ShowSignIn extends AuthState {
  ShowSignIn({isBusy, error, message})
      : super(isBusy: isBusy, error: error, message: message);
}

class ShowRegistration extends AuthState {
  ShowRegistration({isBusy, error, message})
      : super(isBusy: isBusy, error: error, message: message);
}

class CodeSended extends AuthState {
  final String number;
  CodeSended({required this.number, isBusy, error, message})
      : super(isBusy: isBusy, error: error, message: message);
}

class Authentificated extends AuthState {}

//

class VerificationCodeInvalid extends AuthState {}

class ShowDataUpdate extends AuthState {}
