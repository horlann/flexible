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

  // Uses for resend code
  String? signPhoneNumber;

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
    // Sent sms to user and wait for verification
    if (event is SignInByPhone) {
      isRegistration = false;
      // Save phone
      signPhoneNumber = event.phone;
      await fireAuthService.verifyPhoneNumber(event.phone);
      yield CodeSended();
    }

    // Register new user
    // Sent sms to user and wait for verification
    // Save name and email localy and add it to userdata after verification
    if (event is CreateAccount) {
      isRegistration = true;
      // Save phone
      signPhoneNumber = event.phone;
      // Save user data
      userData = UserData(
          fullName: event.name,
          email: event.email,
          phoneNumber: event.phone,
          photo: event.photo);

      try {
        await fireAuthService.verifyPhoneNumber(event.phone);
        yield CodeSended();
      } catch (e) {
        print('Registration error');
        yield ShowRegistration();
      }
    }

    // Resend code to last number
    if (event is ResendCode) {
      await fireAuthService.verifyPhoneNumber(signPhoneNumber!);
      yield CodeSended();
    }

    // Verify sms code
    if (event is VerifyCode) {
      print(event.smsCode);
      try {
        await fireAuthService.signInWithSmsCode(event.smsCode);

        // Check if user data stored before
        if (await usersDataRepo.existsByPhone(signPhoneNumber!)) {
          yield Authentificated();
        } else {
          // If its registration pass new data
          if (isRegistration) {
            await usersDataRepo.setUser(
                userData!.copyWith(uid: fireAuthService.getUser()!.uid));
            yield Authentificated();
          } else {
            yield ShowDataUpdate();
          }
        }
      } catch (e) {
        print('Verification error');
        print(e);
        yield VerificationCodeInvalid();
      }
    }

    // sign out
    if (event is SignOut) {
      await fireAuthService.signOut();
      yield* mapCheckAuthStatus();
    }

    // Add data to user if user dont register before or clic sign in instead of registration
    if (event is AddData) {
      try {
        User fireuser = fireAuthService.getUser()!;

        UserData newUserData = UserData(
            uid: fireuser.uid,
            fullName: event.name,
            email: event.email,
            phoneNumber: signPhoneNumber!,
            photo: event.photo);

        await usersDataRepo.setUser(newUserData);

        yield* mapCheckAuthStatus();
      } catch (e) {
        print('error when update user data');
        print(e);
      }
    }
  }

  // Check auth status and return state by result
  Stream<AuthState> mapCheckAuthStatus() async* {
    if (fireAuthService.isAuthenticated) {
      // The check
      yield Authentificated();
    } else {
      yield ShowRegistration();
    }
  }
}
