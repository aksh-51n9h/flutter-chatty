import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(String fullname, String email, String username,
      String password, bool isLoginForm, BuildContext ctx) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoginForm = true;

  String _fullname = '';
  String _username = 'User';
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (ctx, constraints) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildUserAvatar(constraints),
                    _buildUserDisplayName(context),
                    if (_isLoginForm) _buildUserSignInInfo(context),
                    if (!_isLoginForm) _buildFullnameTextField(),
                    if (!_isLoginForm) _buildUsernameTextField(),
                    _buildUserEmailTextField(),
                    _buildUserPasswordTextField(),
                    _buildFormStateChangeButton(),
                    _buildSumbitButton(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_fullname, _email.trim(), _username.trim(),
          _password, _isLoginForm, context);
    }
  }


  Widget _buildSumbitButton() {
    return Center(
      child: RaisedButton(
        child: Text(_isLoginForm ? 'Sign in' : 'Sign up'),
        onPressed: _trySubmit,
      ),
    );
  }

  Widget _buildUsernameTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        key: ValueKey('Username'),
        obscureText: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
          labelText: 'Username',
        ),
        onChanged: (value) {
          if (value.length > 0) {
            this._username = value;
          } else {
            this._username = 'User';
          }
        },
      ),
    );
  }

  Widget _buildUserPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        key: ValueKey('Password'),
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
          labelText: 'Password',
          suffixIcon: Icon(Icons.remove_red_eye),
        ),
      ),
    );
  }

  Widget _buildUserEmailTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        key: ValueKey('Email'),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
          labelText: 'Email address',
        ),
      ),
    );
  }

  Widget _buildUserSignInInfo(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          'Sign in with your account',
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }

  Widget _buildUserDisplayName(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Hi ${this._username}',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
    );
  }

  Widget _buildUserAvatar(BoxConstraints constraints) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: constraints.maxHeight * 0.11,
        width: constraints.maxHeight * 0.11,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.person,
          size: constraints.maxHeight * 0.07,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildFormStateChangeButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: FlatButton(
        child: Text(
            _isLoginForm
                ? 'Create new account'.toUpperCase()
                : 'Already have account'.toUpperCase(),
            style: Theme.of(context).textTheme.caption),
        onPressed: _changeState,
      ),
    );
  }

  void _changeState() {
    setState(() {
      _isLoginForm = !_isLoginForm;
      this._username = 'User';
    });
  }

  Widget _buildFullnameTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          key: ValueKey('Fullname'),
          obscureText: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            labelText: 'Full name',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your full name.';
            }

            return null;
          }),
    );
  }
}
