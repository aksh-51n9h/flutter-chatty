import 'package:chatty/widgets/picker/user_avatar_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(String fullName, String email, String username,
      String password, bool isLogin, BuildContext ctx) submitFn;

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

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_fullname, _email.trim(), _username.trim(), _password,
          _isLoginForm, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool _isLoading = widget.isLoading;

    return SafeArea(
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          if (_isLoading) return _buildLoading(constraints);

          return Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isLoginForm) _buildUserAvatar(constraints),
                      if (!_isLoginForm) UserAvatarPicker(constraints),
                      _buildUserDisplayName(context),
                      _buildUserSignInInfo(context),
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoading(BoxConstraints constraints) {
    return Center(
      child: Container(
        width: constraints.maxWidth * 0.4,
        height: constraints.maxHeight * 0.09,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Please wait', style: Theme.of(context).textTheme.caption),
            LinearProgressIndicator(),
          ],
        ),
      ),
    );
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
        onChanged: (value) {
          this._password = value;
        },
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
        onChanged: (value) {
          this._email = value;
        },
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
          image: DecorationImage(
            image: AssetImage('assets/images/user_avatars/5.jpg'),
          ),
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
                : 'I already have an account'.toUpperCase(),
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
