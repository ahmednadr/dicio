import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:test/api/auth.dart';

class LogIn extends ConsumerStatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  ConsumerState<LogIn> createState() => _LogInState();
}

class _LogInState extends ConsumerState<LogIn> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String? _username;
    String? _password;
    final auth = ref.read(authProvider);

    Future<void> loginAndAuth() async {
      final valid = formKey.currentState?.validate();
      if (valid!) {
        var token = await auth.Authenticate(_username!, _password!);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => Text("register"))));
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          // decoration: const BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage("lib/assets/images/background.png"),
          //         fit: BoxFit.cover)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 150, sigmaY: 50),
            child: Container(
              color: Colors.black.withOpacity(0.2),
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
                            children: [
                              inputField(
                                onChanged: (value) => _username = value.trim(),
                                field: 'Username',
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                              inputField(
                                onChanged: (value) => _password = value.trim(),
                                field: 'Password',
                                onFieldSubmitted: (pass) {
                                  loginAndAuth();
                                },
                              ),
                              const SizedBox(
                                height: 80.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  minWidth: 40,
                                  onPressed: () => loginAndAuth(),
                                  child: const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  color: Colors.white,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
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
