import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html';

class User {
  String username;
  int id;
  User.fromJson(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'];
    this.username = jsonMap['username'];
  }
}

class ShoppingList {
  String name;
  //date
  String creator;
  int id;
  int group_id;
  ShoppingList(this.id, this.name, this.creator);
  ShoppingList.fromJson(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'];
    this.name = jsonMap['name'];
    this.creator = jsonMap['username'];
    this.group_id = jsonMap['group_id'];
  }
}

class ShoppingListProvider extends ChangeNotifier {
  int group_id;
  List<ShoppingList> lists = [];
  List<User> users;

  static const base_url = "192.168.1.122:5000";
  var client = http.Client();
  final Storage _localStorage = window.localStorage;
  String jwt;
  String username;

  ShoppingListProvider(int group_id) {
    this.group_id = group_id;
    _init(group_id);
  }

  void _init(group_id) async {
    jwt = _localStorage['jwt'];
    username = _localStorage['username'];
    if (jwt != null && username != null) {
      var response = await client.get(
        Uri.http(ShoppingListProvider.base_url, '/lists/get/${group_id}'),
        headers: {
          'Authorization': jwt,
        },
      );
      var body = jsonDecode(response.body).cast<Map<String, dynamic>>();
      this.lists = body
          .map<ShoppingList>((bodyMap) => ShoppingList.fromJson(bodyMap))
          .toList();
      var usersresponse = await client.get(
        Uri.http(ShoppingListProvider.base_url, '/group/users/${group_id}'),
        headers: {
          'Authorization': jwt,
        },
      );
      var userbody =
          jsonDecode(usersresponse.body).cast<Map<String, dynamic>>();
      this.users =
          userbody.map<User>((bodyMap) => User.fromJson(bodyMap)).toList();
      notifyListeners();
    }
  }

  addShoppingList(name) async {
    try {
      var response = await client.get(
        Uri.http(ShoppingListProvider.base_url, '/lists/create/${group_id}', {
          'name': name,
        }),
        headers: {
          'Authorization': jwt,
        },
      );
      var body = jsonDecode(response.body).cast<Map<String, dynamic>>();
      lists = [...lists, ShoppingList.fromJson(body[0])];
    } catch (err) {
      print(err);
    }
  }

  deleteShoppingList(id) async {
    try {
      var response = await client.get(
        Uri.http(ShoppingListProvider.base_url, '/lists/delete/${id}'),
        headers: {
          'Authorization': jwt,
        },
      );
      //var body = jsonDecode(response.body).cast<Map<String, dynamic>>();
      lists.removeWhere((element) => element.id == id);
      //lists = [...lists, ShoppingList.fromJson(body[0])];
    } catch (err) {
      print(err);
    }
  }

  deleteGroup() async {
    try {
      var response = await client.get(
          Uri.http(ShoppingListProvider.base_url, '/groups/delete/${group_id}'),
          headers: {
            'Authorization': jwt,
          });
    } catch (err) {}
  }

  inviteUser(String username) async {
    try {
      await client.get(
          new Uri.http(
            ShoppingListProvider.base_url,
            '/group/invite/send/${group_id}',
            {
              'username': username,
            },
          ),
          headers: {
            'Authorization': jwt,
          });
    } catch (err) {
      print(err);
    }
  }

  editShoppingList() {}
}
