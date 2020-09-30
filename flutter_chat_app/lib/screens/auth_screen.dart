import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitForm(BuildContext ctx, String email, String name, String password,
      File userImage, bool isLogin) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${authResult.user.uid}.jpg');

        await ref.putFile(userImage).onComplete;
        final imageUrl = await ref.getDownloadURL();

        Firestore.instance
            .collection("users")
            .document(authResult.user.uid)
            .setData({'username': name, 'email': email, 'image_url': imageUrl});
      }
    } on PlatformException catch (err) {
      var message = 'Please check your credentials there is some error';
      if (err != null) message = err.message;
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
        duration: Duration(seconds: 2),
      ));
    } catch (error) {
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text("Something went wrong"),
        duration: Duration(seconds: 2),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitForm, _isLoading),
    );
  }
}
