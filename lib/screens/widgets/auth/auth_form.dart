import 'dart:io';
import 'package:chatty/screens/widgets/picker/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(String fullName, String email, String username,
      String password, File userImage, bool isLogin, BuildContext ctx) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  bool _isLogin = true;
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();

    if (!_isLogin && _userImageFile == null) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Please pick an image.')));
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_fullName, _userEmail.trim(), _userName.trim(),
          _userPassword, _userImageFile, _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Theme.of(context).primaryColor,
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  SizedBox(height: 8),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('fullname'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        hintText: 'Full Name',
                      ),
                      onSaved: (value) {
                        _fullName = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your full name.';
                        }

                        return null;
                      },
                    ),
                  SizedBox(height: 8),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        hintText: 'Username',
                      ),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  SizedBox(height: 8),
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@gmail.com')) {
                        return 'Invalid email address';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: 'Email',
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    key: ValueKey('password'),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 8) {
                        return 'Minimun password length is 8 characters';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: 'Password',
                    ),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(height: 15),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Sign up'),
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
