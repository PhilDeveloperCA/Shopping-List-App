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
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ShoppingListProvider(widget.group.id),
      builder: (context, child) => BodyWidget(context),
    );
  }

  Widget BodyWidget(context) {
    final list = Provider.of<ShoppingListProvider>(context);
    print(list.lists);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
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
