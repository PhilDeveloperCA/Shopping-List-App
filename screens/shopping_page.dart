import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_client/util/itemlist_provider.dart';
import 'package:shopping_client/util/route_info.dart';
import 'package:shopping_client/util/shoppinglist_provider.dart';

class ShoppingListPage extends StatefulWidget {
  ShoppingList list;
  ShoppingListPage(this.list);
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ItemProvider(widget.list.id),
        builder: (context, child) => BodyWidget(context));
  }

  BodyWidget(context) {
    final items = Provider.of<ItemProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list.name),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 500,
            child: ListView.builder(
              itemCount: items.items.length,
              itemBuilder: (context, index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(items.items[index].name),
                  Text(items.items[index].username),
                  FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteNames.shopping);
                    },
                    label: Text('Details'),
                    icon: Icon(Icons.details),
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
