import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:test/api/auth.dart';
import 'package:test/api/config.dart';

class LogIn extends ConsumerStatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  ConsumerState<LogIn> createState() => _LogInState();
}

class _LogInState extends ConsumerState<LogIn> with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    String? _username;
    String? _password;
    final auth = ref.read(authProvider);
    final config = ref.read(configProvider);

    Future<void> loginAndAuth() async {
      final valid = formKey.currentState?.validate();
      if (valid!) {
        var token = await auth.authenticate(_username!, _password!);
        config.setToken(auth.ip, token);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: ((context) =>
                    Text("${config.activeIp} token ${config.token}"))));
      }
    }

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
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom + 10),
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
                                onChanged: (value) => _username = value.trim(),
                                field: 'Username',
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              inputField(
                                onChanged: (value) => _password = value.trim(),
                                field: 'Password',
                                onFieldSubmitted: (pass) {
                                  loginAndAuth();
                                },
                              ),
                              const SizedBox(
                                height: 50.0,
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minWidth: 40,
                                    onPressed: () => loginAndAuth(),
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
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
}

Card inputField(
    {required Function(String value) onChanged,
    required String field,
    Function(String value)? onFieldSubmitted}) {
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: TextFormField(
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
      ));
}
