import 'dart:io';

import 'package:flutter/material.dart';
import '../pickers/user_image.dart';

class AuthForm extends StatefulWidget {
  final void Function(BuildContext ctx, String email, String name,
      String password, File userImage, bool isLogin) submitForm;
  final isLoading;

  AuthForm(this.submitForm, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _globalKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImage;

  void _setUserImage(File image) {
    setState(() {
      _userImage = image;
    });
  }

  void _trySubmit() {
    final isValid = _globalKey.currentState.validate();
    FocusScope.of(context).unfocus(); // close the keyboard

    if (_userImage == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please select an image'),
        backgroundColor: Theme.of(context).errorColor,
        duration: Duration(seconds: 2),
      ));
      return;
    }
    if (!isValid) return;
    _globalKey.currentState.save();
    widget.submitForm(
        context, _userEmail, _userName, _userPassword, _userImage, _isLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _globalKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // for min size in main axis
              children: <Widget>[
                if (!_isLogin) UserImage(_setUserImage),
                TextFormField(
                  key: ValueKey('email'),
                  // used for compiler to identify same widget according to keys
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  validator: (value) {
                    if (value.isEmpty || !value.contains("@"))
                      return 'Please Enter the valid email';
                    return null;
                  },
                  onSaved: (value) {
                    _userEmail = value;
                  },
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 4)
                        return 'Please Enter the valid username of length>4';
                      return null;
                    },
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    onSaved: (value) {
                      _userName = value;
                    },
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value.isEmpty || value.length < 7)
                      return 'Please Enter the valid password of length>7';
                    return null;
                  },
                  onSaved: (value) {
                    _userPassword = value;
                  },
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(
                  height: 10,
                ),
                if (!widget.isLoading)
                  RaisedButton(
                    child: Text(_isLogin ? 'Login' : 'Sign Up'),
                    onPressed: _trySubmit,
                  ),
                if (widget.isLoading) CircularProgressIndicator(),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                      _isLogin ? 'Create New Account' : 'I Already Have One'),
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
