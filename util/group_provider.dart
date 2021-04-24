import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:html';

class Group {
  String name;
  String admin;
  //Date Later
  // List<String> group_members;
  int id;
  Group(this.id, this.name);

  Group.fromJson(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'] as int;
    this.name = jsonMap['name'] as String;
    this.admin = jsonMap['admin'] as String;
  }
}

class GroupProvider extends ChangeNotifier {
  static const base_url = "192.168.1.122:5000";
  var client = http.Client();
  final Storage _localStorage = window.localStorage;
  List<Group> groups = [];
  String jwt;
  String username;

  GroupProvider() {
    _init();
  }

  void _init() async {
    jwt = _localStorage['jwt'];
    username = _localStorage['username'];
    if (jwt != null && username != null) {
      var response = await client.get(
        Uri.http(GroupProvider.base_url, '/group/group/mygroups'),
        headers: {
          'Authorization': jwt,
        },
      );
      var body = jsonDecode(response.body).cast<Map<String, dynamic>>();
      this.groups =
          body.map<Group>((bodyMap) => Group.fromJson(bodyMap)).toList();
      notifyListeners();
    }
  }

  fetchGroups() async {
    var response = await client.get(
        new Uri.http(GroupProvider.base_url, '/group/group/mygroups'),
        headers: {});
    notifyListeners();
  }

  createGroup(dynamic name) async {
    try {
      var response = await client.get(
        new Uri.http(GroupProvider.base_url, '/group/create', {
          'name': name,
        }),
        headers: {
          'Authorization': jwt,
        },
      );
      groups.add(Group.fromJson(jsonDecode(response.body)));
    } catch (err) {
      print(err);
    }
  }

  leaveGroup() async {}

  deleteGroup() async {}
}
