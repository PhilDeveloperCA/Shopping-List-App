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

  @override
  void dispose() {
    _usernameController.dispose();
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
                      FloatingActionButton(onPressed: () {
                        if (_formKey.currentState.validate()) {
                          list.inviteUser(username);
                        }
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.people), onPressed: _showDialog)
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
                  Text(list.lists[index].name),
                  Text(list.lists[index].creator),
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
