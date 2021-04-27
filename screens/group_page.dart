import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shopping_client/util/group_provider.dart';
import 'package:shopping_client/util/route_info.dart';
import 'package:shopping_client/util/shoppinglist_provider.dart';

class GroupPage extends StatefulWidget {
  Group group;
  GroupPage(this.group);
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  String username;
  final _usernameController = TextEditingController();
  String listname;
  final _listnameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _listnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ShoppingListProvider(widget.group.id),
      builder: (context, child) => BodyWidget(context),
    );
  }

  Widget BodyWidget(context) {
    final list = Provider.of<ShoppingListProvider>(context);
    final _formKey = GlobalKey<FormState>();
    final _formKey2 = GlobalKey<FormState>();
    //final Stream

    _showDialog() {
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
              Container(
                padding: EdgeInsets.only(top: 40.0),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) =>
                            value.length > 5 ? null : 'Enter Valid Username',
                        onChanged: (value) => setState(() => username = value),
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'enter user',
                          labelText: 'Invite User by Username',
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                      FloatingActionButton(onPressed: () {
                        if (_formKey.currentState.validate()) {
                          list.inviteUser(username);
                        }
                      })
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: list.users
                      .map((user) => Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.blue,
                              width: 4,
                            )),
                            child: Row(children: [
                              Text(user.username),
                              user.username == widget.group.admin
                                  ? Icon(Icons.group)
                                  : Container(),
                            ]),
                          ))
                      .toList(),
                ),
              )
            ],
          ),
        ),
      );
    }

    _showDeleteDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          clipBehavior: Clip.hardEdge,
          content: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 35.0),
                child: InkResponse(
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    }),
              ),
              Container(
                padding: EdgeInsets.only(top: 70),
                child: FloatingActionButton.extended(
                    backgroundColor: Colors.red[500],
                    onPressed: () async {
                      await list.deleteGroup();
                      Navigator.pushNamed(context, '/');
                    },
                    label: Text('Are you Sure you want to leave this group'),
                    icon: Icon(Icons.delete)),
              ),
            ],
          ),
        ),
      );
    }

    _showShoppingForm() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Stack(
            clipBehavior: Clip.hardEdge,
            children: <Widget>[
              Container(
                child: InkResponse(
                    child: Icon(Icons.close), onTap: Navigator.of(context).pop),
              ),
              Container(
                child: Form(
                  key: _formKey2,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) =>
                            value.length > 3 ? 'Enter Valid List Name' : null,
                        controller: _listnameController,
                      ),
                      FloatingActionButton(
                          onPressed: () async {
                            if (_formKey2.currentState.validate()) {
                              await list
                                  .addShoppingList(_listnameController.text);
                            }
                          },
                          child: Text('Submit'))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.people), onPressed: _showDialog),
          widget.group.admin == list.username
              ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _showDeleteDialog,
                )
              : Container(),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: _showShoppingForm,
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 500,
            child: ListView.builder(
              itemCount: list.lists.length,
              itemBuilder: (context, index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(list.lists[index].name == null
                      ? ''
                      : list.lists[index].name),
                  Align(
                    child: Text(list.lists[index].creator),
                    alignment: Alignment.centerLeft,
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteNames.shopping,
                          arguments: list.lists[index]);
                    },
                    label: Text('Details'),
                    icon: Icon(Icons.details),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
