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
  int index = 0;
  String name;
  String description;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool calculate = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      print(name);
      setState(() => this.name = _nameController.text);
    });
    _descriptionController.addListener(() {
      setState(() => this.description = _descriptionController.text);
    });
    //add listeners
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ItemProvider(widget.list.id),
        builder: (context, child) => BodyWidget(context));
  }

  BodyWidget(context) {
    final items = Provider.of<ItemProvider>(context);
    print(items.username);
    void Submit() {
      if (_formKey.currentState.validate()) {
        items.addItem(name, description);
      }
    }

    Future<void> _showDialog() {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Stack(
            clipBehavior: Clip.hardEdge,
            children: <Widget>[
              InkResponse(
                onTap: () => Navigator.of(context).pop(),
                child: CircleAvatar(
                  child: Icon(Icons.close),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Name'),
                    Container(
                      child: TextFormField(
                        validator: (value) =>
                            value.length > 3 ? null : 'Enter Valid Name',
                        controller: _nameController,
                      ),
                    ),
                    Text('Description'),
                    Container(
                      child: TextFormField(
                        validator: (value) =>
                            value.length > 3 ? null : 'Enter Valid Name',
                        controller: _descriptionController,
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: Submit,
                      child: Text('Submit'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FloatingActionButton.extended(
              onPressed: _showDialog,
              label: Text('Add Item'),
              icon: Icon(Icons.add),
            ),
            SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: items.items.length,
                itemBuilder: (context, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(items.items[index].name),
                    Text(items.items[index].username),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            //Navigator.pushNamed(context, RouteNames.shopping);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Stack(
                                  clipBehavior: Clip.hardEdge,
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 25.0),
                                      child: FloatingActionButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: CircleAvatar(
                                          child: Icon(Icons.close),
                                        ),
                                      ),
                                    ),
                                    Text(items.items[index].description)
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.details),
                          iconSize: 24.0,
                        ),
                        items.username == items.items[index].username
                            ? IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  items.deleteItem(items.items[index].id);
                                })
                            : Container(),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
