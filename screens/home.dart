import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shopping_client/auth_provider.dart';
import 'package:shopping_client/util/group_provider.dart';
import 'package:shopping_client/util/route_info.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authstate = Provider.of<AuthProvider>(context);
    if (!authstate.authenticated) {
      return Auth();
    } else
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<GroupProvider>(
            create: (context) => GroupProvider(),
          ),
        ],
        builder: (context, child) => GroupWidget(context),
      );
  }
}

Widget GroupWidget(context) {
  final groups =
      Provider.of<GroupProvider>(context, listen: false).groups.length;

  return Scaffold(
    appBar: AppBar(
      title: Text('Your Apps'),
    ),
    body: Column(
      children: [
        SizedBox(
          height: 500,
          child: ListView.builder(
            itemCount: Provider.of<GroupProvider>(context).groups.length,
            itemBuilder: (context, index) => Row(
              children: [
                Text(Provider.of<GroupProvider>(context).groups[index].name),
                FloatingActionButton.extended(
                  icon: Icon(Icons.details),
                  label: Text('Details'),
                  onPressed: () async {
                    print('here');
                    await Navigator.pushNamed(context, RouteNames.group,
                        arguments:
                            Provider.of<GroupProvider>(context, listen: false)
                                .groups[index]);
                  },
                )
              ],
            ),
          ),
        )
      ],
    ),
  );
}

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
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
      /*if (auth.authenticated) {
        Future.delayed(Duration.zero, () {
          Navigator.pushNamed(context, '/');
        });
      }*/
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
