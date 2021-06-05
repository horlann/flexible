part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class CodeSended extends AuthState {}

class Authentificated extends AuthState {}

class NotAuthentificated extends AuthState {}
