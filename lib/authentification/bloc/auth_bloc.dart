import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexible/authentification/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.fireAuthService}) : super(AuthInitial());

  late FireAuthService fireAuthService;

  String registratonName = '';
  String registrationEmail = '';

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    // On app start check auth state
    if (event is AppStart) {
      yield* mapCheckAuthStatus();
    }

    // Show user SignIn page
    if (event is GoToSignIn) {
      yield ShowSignIn();
    }

    // Show user registration page
    if (event is GoToRegistration) {
      yield ShowRegistration();
    }

    // Sign by phone
    // Sent sms to user and wait for verification
    if (event is SignInByPhone) {
      await fireAuthService.verifyPhoneNumber(event.phone);
      yield CodeSended();
    }

    // Register new user
    // Sent sms to user and wait for verification
    // Save name and email localy and add it to userdata after verification
    if (event is CreateAccount) {
      registratonName = event.name;
      registrationEmail = event.email;

      try {
        await fireAuthService.verifyPhoneNumber(event.phone);
      } catch (e) {
        print('Registration error');
        yield NotAuthentificated();
        return;
      }
      yield CodeSended();
    }

    // Verify sms code
    if (event is VerifyCode) {
      try {
        await fireAuthService.signInWithSmsCode(event.smsCode);
      } catch (e) {
        print('Verification error');
        yield VerificationCodeInvalid();
        return;
      }
      yield* mapCheckAuthStatus();
    }

    // sign out
    if (event is SignOut) {
      await fireAuthService.signOut();
      yield* mapCheckAuthStatus();
    }

    // Add data to user if user dont register before or clic sign in instead of registration
    if (event is AddData) {
      try {
        print(event.email);
        User fireuser = fireAuthService.getUser()!;
        await fireuser.updateDisplayName(event.name);
        // await fireuser.updateEmail(event.email);
      } catch (e) {
        print('error when update user data');
      }

      yield* mapCheckAuthStatus();
    }
  }

  // Check auth status and return state by result
  Stream<AuthState> mapCheckAuthStatus() async* {
    if (fireAuthService.isAuthenticated) {
      //
      // Check user data and update
      // Its need to add user name and email to userdata after sms verification
      // Or if user try to signin first
      User fireuser = fireAuthService.getUser()!;
      print(fireuser);
      if (fireuser.displayName == null) {
        // if after sms code verified
        // complete registration
        if (registratonName.isNotEmpty && registrationEmail.isNotEmpty) {
          fireuser.updateDisplayName(registratonName);
          // fireuser.updateEmail(registrationEmail);
          Authentificated();
        } else {
          // if user sign in before registration
          // shou page with name and email input
          yield ShowDataUpdate();
          return;
        }
      }

      // The check
      yield Authentificated();
    } else {
      yield ShowRegistration();
    }
  }
}
