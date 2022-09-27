import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:test/ui/screens/LoginPage/login_states.dart';
import 'package:test/ui/screens/LoginPage/login_view_model.dart';

class LogIn extends ConsumerStatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  ConsumerState<LogIn> createState() => _LogInState();
}

class _LogInState extends ConsumerState<LogIn> with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  // late final AnimationController _controller = AnimationController(
  //   duration: const Duration(seconds: 1),
  //   vsync: this,
  // );
  String? _username;
  String? _password;
  late LoginViewModel vm;
  late bool isLoading;
  FocusNode loginFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final viewModelState = ref.watch(LoginViewModel.loginViewModelProvider);
    vm = ref.read(LoginViewModel.loginViewModelProvider.notifier);

    handleStates(viewModelState);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/assets/images/background.png"),
                  fit: BoxFit.cover)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 150, sigmaY: 50),
            child: Container(
              color: Colors.white.withOpacity(0.20),
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Welcome to Dicio.",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600),
                              ),
                              const Text(
                                " Your home in your pocket.",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              inputField(
                                  focusNode: loginFocusNode,
                                  onChanged: (value) =>
                                      _username = value.trim(),
                                  field: 'Username',
                                  active: !isLoading,
                                  onFieldSubmitted: (value) =>
                                      passFocusNode.requestFocus()),
                              const SizedBox(
                                height: 10.0,
                              ),
                              inputField(
                                focusNode: passFocusNode,
                                onChanged: (value) => _password = value.trim(),
                                field: 'Password',
                                active: !isLoading,
                                onFieldSubmitted: (pass) {
                                  FocusScope.of(context).unfocus();
                                  vm.loginAndAuth(
                                      formKey: formKey,
                                      username: _username,
                                      password: _password);
                                },
                              ),
                              const SizedBox(
                                height: 50.0,
                              ),
                              loginButton(isLoading: isLoading),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Center loginButton({required bool isLoading}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minWidth: 40,
          onPressed: () {
            FocusScope.of(context).unfocus();
            vm.loginAndAuth(
                formKey: formKey, username: _username, password: _password);
          },
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: !isLoading
                  ? const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    )
                  : const CircularProgressIndicator()),
          color: Colors.white,
        ),
      ),
    );
  }

  Card inputField(
      {required Function(String value) onChanged,
      required String field,
      Function(String value)? onFieldSubmitted,
      required bool active,
      FocusNode? focusNode}) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            width: 3,
            color: Colors.white,
          ),
        ),
        color: Colors.white24,
        elevation: 0,
        child: SizedBox(
          height: 75,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Center(
              child: TextFormField(
                focusNode: focusNode,
                readOnly: !active,
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: InputBorder.none,
                    hintText: field),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a ${field.toLowerCase()}';
                  }
                  return null;
                },
                onChanged: onChanged,
                onFieldSubmitted: onFieldSubmitted,
              ),
            ),
          ),
        ));
  }

  void handleStates(LoginStates state) {
    isLoading = state == LoginStates.loading;
    switch (state) {
      case LoginStates.error:
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          vm.handleError(context);
        });
        break;
      case LoginStates.success:
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          vm.goNext(context);
        });
        break;
      default:
    }
  }
}
