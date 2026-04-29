import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/firestore_services.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final FirebaseServices service;

  AuthCubit(this.service) : super(AuthInitialState());

  Future<void> register(String email, String password, String name) async {
    emit(AuthLoadingState());

    try {
      final user = await service.register(email, password, name);
      emit(AuthSuccessState(user!));
    } catch (error) {
      emit(AuthFailureState(error.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoadingState());

    try {
      final user = await service.login(email, password);
      emit(AuthSuccessState(user!));
    } catch (error) {
      emit(AuthFailureState(error.toString()));
    }
  }

  Future<void> logout() async {
    await service.logout();
    emit(AuthLoggedOutState());
  }

  Future<void> updateUserInfo({
    String? newName,
  }) async {
    emit(AuthLoadingState());

    try {
      final updatedUser = await service.updateUserInfo(
        newName: newName,
      );
      emit(AuthSuccessState(updatedUser!));
    } catch (error) {
      emit(AuthFailureState(error.toString()));
    }
  }
}
