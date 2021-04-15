import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth_provider.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  int index = 0;
  String username;
  String password;

  _userListener() {
    if (_usernameController.text != '') {
      setState(() {
        username = _usernameController.text;
      });
    }
  }

  _passwordListener() {
    if (_passwordController.text != '') {
      setState(() {
        password = _passwordController.text;
      });
    }
  }

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_userListener);
    _passwordController.addListener(_passwordListener);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    Future<void> submit() async {
      await auth.login(username, password);
      print(auth.authenticated);
      if (auth.authenticated) {
        Future.delayed(Duration.zero, () {
          Navigator.pushNamed(context, '/');
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Login / Register'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Text('Existing User ?'),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    index = 0;
                  });
                },
                child: Text('Sign In'),
              )
            ],
          ),
          Column(
            children: [
              Text('New ?'),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    index = 1;
                  });
                },
                child: Text('Sign Up'),
              )
            ],
          ),
          Form(
            child: Column(
              children: [
                TextFormField(
                  validator: (value) => value.length > 6 && value.length < 20
                      ? null
                      : 'Enter a Username of at least 6 Characters',
                  controller: _usernameController,
                ),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) => value.length > 6 && value.length < 250
                      ? null
                      : 'Enter a Passsword of at least 6 characters',
                ),
                FloatingActionButton(
                  onPressed: submit,
                  child: Text('Submit'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
