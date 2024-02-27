import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
  ) _loginFuntion;

  final bool _isLoading;

  const AuthForm(this._loginFuntion, this._isLoading, {super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String email = "";
    String password = "";

    void tryLogin() {
      _formKey.currentState?.save();
      widget._loginFuntion(
        email.trim(),
        password.trim(),
      );
    }

    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "電郵"),
                  onSaved: (value) {
                    email = value!;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "密碼"),
                  onSaved: (value) {
                    password = value!;
                  },
                ),
                const SizedBox(height: 12),
                widget._isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          tryLogin();
                        },
                        child: const Text("登入"),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
