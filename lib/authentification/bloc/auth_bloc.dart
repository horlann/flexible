import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexible/authentification/models/user_data_model.dart';
import 'package:flexible/authentification/services/firebase_auth.dart';
import 'package:flexible/authentification/services/users_data_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.fireAuthService, required this.usersDataRepo})
      : super(AuthInitial());

  late FireAuthService fireAuthService;
  late UsersDataRepo usersDataRepo;

  // Uses for complete registration
  // On user register set userdata there and use after confirmation
  UserData? userData;

  // Mark for verify completition check
  bool isRegistration = false;

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
    if (event is SignInByPhone) {
      yield ShowSignIn(isBusy: true);
      try {
        // Check if user register before
        bool isExits = await usersDataRepo.existsByPhone(event.phone);
        if (!isExits) {
          yield ShowSignIn(error: 'User found\'nt, sign up first');
        } else {
          isRegistration = false;
          // Sent sms to user and wait for verification
          await fireAuthService.verifyPhoneNumber(event.phone);
          yield CodeSended(number: event.phone);
        }
      } catch (e) {
        yield ShowSignIn(error: e.toString());
      }
    }

    // Register new user
    // Sent sms to user and wait for verification
    // Save name and email localy and add it to userdata after verification
    if (event is CreateAccount) {
      yield ShowRegistration(isBusy: true);
      try {
        // Check if user register before
        bool isExits = await usersDataRepo.existsByPhone(event.phone);
        if (isExits) {
          yield ShowRegistration(
              error: 'User already registrated, sign in please');
        } else {
          isRegistration = true;
          // Save user data
          userData = UserData(
              fullName: event.name,
              email: event.email,
              phoneNumber: event.phone,
              photo: event.photo);
          await fireAuthService.verifyPhoneNumber(event.phone);
          yield CodeSended(number: event.phone);
        }
      } catch (e) {
        print('Registration error');
        yield ShowRegistration(error: e.toString());
      }
    }

    // Resend code to last number
    if (event is ResendCode) {
      yield CodeSended(number: event.number, isBusy: true);
      try {
        await fireAuthService.verifyPhoneNumber(event.number);
        yield CodeSended(number: event.number, message: 'Code resended');
      } catch (e) {
        yield CodeSended(number: event.number, error: e.toString());
      }
    }

    // Verify sms code
    if (event is VerifyCode) {
      yield CodeSended(number: event.number, isBusy: true);
      try {
        await fireAuthService.signInWithSmsCode(event.smsCode);

        // If it registration add new user data
        if (isRegistration) {
          await usersDataRepo
              .setUser(userData!.copyWith(uid: fireAuthService.getUser()!.uid));
        }
        yield Authentificated();
      } catch (e) {
        print('Code verification error');
        print(e);
        yield CodeSended(number: event.number, error: e.toString());
      }
    }

    // sign out
    if (event is SignOut) {
      await fireAuthService.signOut();
      yield* mapCheckAuthStatus();
    }
  }

  // Check auth status and return state by result
  Stream<AuthState> mapCheckAuthStatus() async* {
    print('asdsd');
    if (fireAuthService.isAuthenticated) {
      // The check
      yield Authentificated();
    } else {
      yield ShowRegistration();
    }
  }
}
