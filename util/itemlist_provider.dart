import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:html';

class Item {
  int id;
  String username;
  String name;
  String description;
  double cost = 0.00;
  int quantity = 0;
  Item(this.id, this.username, this.name);
  Item.fromJson(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'];
    this.username = jsonMap['username'];
    this.name = jsonMap['name'];
    this.description = jsonMap['description'];
  }
}

class ItemProvider extends ChangeNotifier {
  int list_id;
  List<Item> items = [];

  static const base_url = "192.168.1.122:5000";
  var client = http.Client();
  final Storage _localStorage = window.localStorage;
  String jwt;
  String username;

  ItemProvider(this.list_id) {
    _init();
  }

  void _init() async {
    this.jwt = _localStorage['jwt'];
    this.username = _localStorage['username'];
    var response = await client.get(
      Uri.http(ItemProvider.base_url, '/items/get/${list_id}'),
      headers: {
        'Authorization': jwt,
      },
    );
    var body = jsonDecode(response.body).cast<Map<String, dynamic>>();
    this.items = body.map<Item>((bodyMap) => Item.fromJson(bodyMap)).toList();
    notifyListeners();
  }

  void deleteItem(int id) async {
    try {
      var response = await client.get(
        Uri.http(ItemProvider.base_url, '/items/delete/${id}'),
        headers: {
          'Authorization': jwt,
        },
      );
      items.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  void addItem(String name, String description) async {
    try {
      var response = await client.get(
        Uri.http(
          ItemProvider.base_url,
          '/items/add/${list_id}',
          {
            'name': name,
            'description': description,
          },
        ),
        headers: {
          'Authorization': jwt,
        },
      );
      var newItemJson = jsonDecode(response.body);
      Item newItem = Item.fromJson(newItemJson);
      this.items = [...items, newItem];
      print(items);
    } catch (err) {
      print(err);
    }
  }
}

/*void _init(group_id) async {
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
}*/
