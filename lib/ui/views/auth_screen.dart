import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../../locator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _authService = locator<AuthService>();
  var _isLoading = false;

  void _login(String email, String password, BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _authService.login(email: email, password: password);
    } on PlatformException catch (error) {
      var msg = "Login Failed.";
      inspect(error);
      if (error.message != null) {
        msg = error.message!;

        // ignore: use_build_context_synchronously
        (ScaffoldMessenger.of(ctx)..hideCurrentSnackBar()).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).accentColor,
      body: AuthForm(
        _login,
        _isLoading,
      ),
    );
  }
}
