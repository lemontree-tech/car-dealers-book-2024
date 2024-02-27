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

  void _login(String email, String password) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _authService.login(email: email, password: password);
    } on PlatformException catch (error) {
      inspect(error);
    } catch (error) {
      var msg = "Login Failed.";
      // if ((error != null) {
      msg = error.toString();
      // }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // Then, show the new snack bar.
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
        ),
      );
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
