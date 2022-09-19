import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/api/auth.dart';
import 'package:test/api/config.dart';
import 'package:test/ui/screens/LoginPage/login_states.dart';

class LoginViewModel extends StateNotifier<LoginStates> {
  LoginViewModel({required this.auth, required this.config})
      : super(LoginStates.idle);

  final Auth auth;
  final Config config;

  static final loginViewModelProvider =
      StateNotifierProvider<LoginViewModel, LoginStates>((ref) {
    final auth = ref.read(authProvider);
    final config = ref.read(configProvider);
    return LoginViewModel(auth: auth, config: config);
  });

  Future<void> loginAndAuth({
    required GlobalKey<FormState> formKey,
    required String? username,
    required String? password,
  }) async {
    final valid = formKey.currentState?.validate();
    if (valid!) {
      try {
        state = LoginStates.loading;
        var token = await auth.authenticate(username!, password!);
        config.setToken(auth.ip, token);
        state = LoginStates.success;
      } catch (_) {
        state = LoginStates.error;
      }
    }
  }

  void handleError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't login. Please try again")));
    state = LoginStates.idle;
  }

  void goNext(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: ((context) =>
                Text("${config.activeIp} token ${config.token}"))));
  }
}
