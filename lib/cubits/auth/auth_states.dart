import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthSuccessState extends AuthStates {
  final User user;
  AuthSuccessState(this.user);
}

class AuthFailureState extends AuthStates {
  final String message;
  AuthFailureState(this.message);
}

class AuthLoggedOutState extends AuthStates {}