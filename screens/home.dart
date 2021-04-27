import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shopping_client/auth_provider.dart';
import 'package:shopping_client/util/group_provider.dart';
import 'package:shopping_client/util/route_info.dart';
import 'dart:async';

class Home extends StatelessWidget {
  static final _groupNameStream = new StreamController<String>();
  String name;

  @override
  void dispose() {
    _groupNameStream.close();
  }

  static final nameValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) => {
      if (value.length > 3)
        {sink.add(value)}
      else
        sink.addError('Group Must Be At least 4 characters')
    },
  );

  Stream<String> get getName =>
      _groupNameStream.stream.transform(nameValidator);
  Function(String) get changeName => _groupNameStream.sink.add;

  @override
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

  Widget GroupWidget(context) {
    final groups = Provider.of<GroupProvider>(context, listen: false);

    //final Stream
    Future<void> _showDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 25.0),
                child: InkResponse(
                  onTap: () => Navigator.of(context).pop(),
                  child: CircleAvatar(
                    child: Icon(Icons.close),
                  ),
                ),
              ),
              StreamBuilder(
                  builder: (context, name) => Container(
                        padding: EdgeInsets.only(top: 40.0),
                        child: Column(
                          children: [
                            TextField(
                              onChanged: changeName,
                              decoration: InputDecoration(
                                  labelText: 'group name',
                                  errorText: name.error),
                            ),
                            FloatingActionButton(onPressed: () async {
                              if (name.error == null) {
                                groups.createGroup(name.data);
                                Navigator.pop(context);
                              }
                            })
                          ],
                        ),
                      ),
                  stream: getName),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Groups'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: _showDialog)
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 500,
            child: ListView.builder(
              itemCount: Provider.of<GroupProvider>(context).groups.length,
              itemBuilder: (context, index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Provider.of<GroupProvider>(context).groups[index].name),
                  FloatingActionButton.extended(
                    icon: Icon(Icons.shopping_cart),
                    label: Text('See Shopping Lists'),
                    onPressed: () async {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  //Text('Existing User ?'),
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
                  //Text('New ?'),
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
            ],
          ),
          Form(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 150.0, vertical: 30.0),
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
                  Padding(padding: EdgeInsets.only(top: 40.0)),
                  FloatingActionButton(
                    onPressed: submit,
                    child: Text('Submit'),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
