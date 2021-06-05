import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flexible/authentification/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.fireAuthService}) : super(AuthInitial());

  late FireAuthService fireAuthService;

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    // On app start check auth state
    if (event is AppStart) {
      yield* mapCheckAuthStatus();
    }

    if (event is SendCode) {
      await fireAuthService.verifyPhoneNumber(event.phone);
      yield CodeSended();
    }

    if (event is VerifyCode) {
      await fireAuthService.signInWithSmsCode(event.smsCode);
      yield* mapCheckAuthStatus();
    }

    if (event is SignOut) {
      await fireAuthService.signOut();
      yield* mapCheckAuthStatus();
    }
  }

  // Check auth status and return state by result
  Stream<AuthState> mapCheckAuthStatus() async* {
    if (fireAuthService.isAuthenticated) {
      yield Authentificated();
    } else {
      yield NotAuthentificated();
    }
  }
}
