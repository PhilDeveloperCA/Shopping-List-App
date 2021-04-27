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
    void Submit() {
      if (_formKey.currentState.validate()) {
        items.addItem(name, description);
      }
    }

    Widget itemList(List<Item> itemslist) {
      return Container(
        child: SizedBox(
          height: 400,
          child: ListView.builder(
            itemCount: itemslist.length,
            //itemCount: items.items.length,
            itemBuilder: (context, index) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(itemslist[index].name),
                Text(itemslist[index].username),
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
                                  padding: EdgeInsets.only(bottom: 25.0),
                                  child: FloatingActionButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: CircleAvatar(
                                      child: Icon(Icons.close),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 80.0),
                                  child: Text(
                                    '${itemslist[index].name} - ${itemslist[index].username}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 100.0),
                                  child: Text(
                                    itemslist[index].description,
                                    style: TextStyle(color: Colors.blue[400]),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.details),
                      iconSize: 24.0,
                    ),
                    items.username == itemslist[index].username
                        ? IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red[700],
                            onPressed: () {
                              items.deleteItem(itemslist[index].id);
                            })
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.grey,
                            onPressed: () {},
                          ),
                    Checkbox(
                        value: itemslist[index].bought,
                        onChanged: (bool truth) =>
                            items.checkBought(itemslist[index].id, truth)),
                  ],
                )
              ],
            ),
          ),
        ),
      );
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

    Future<void> _confirmDelete() {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              InkResponse(
                onTap: () => Navigator.of(context).pop(),
                child: CircleAvatar(
                  child: Icon(Icons.close),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 100),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.red[500],
                  onPressed: () {
                    items.deleteShoppingList();
                    Navigator.pushNamed(context, '/');
                  },
                  icon: Icon(Icons.delete),
                  label: Text('Are you Sure you Want To Delete This List?'),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _confirmDelete,
          )
        ],
      ),
      body: Row(
        children: [
          LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: NavigationRail(
                      labelType: NavigationRailLabelType.all,
                      selectedIndex: index,
                      onDestinationSelected: (int index) {
                        setState(() => this.index = index);
                      },
                      destinations: <NavigationRailDestination>[
                        NavigationRailDestination(
                            icon: Icon(Icons.radio_button_unchecked),
                            label: Text('Unbought')),
                        NavigationRailDestination(
                          icon: Icon(Icons.check_box),
                          label: Text('Bought'),
                        ),
                        ...items.categories
                            .map((element) => NavigationRailDestination(
                                  icon: Icon(Icons.info),
                                  label: Text(element),
                                ))
                            .toList()
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                FloatingActionButton.extended(
                  onPressed: _showDialog,
                  label: Text('Add Item'),
                  icon: Icon(Icons.add),
                ),
                this.index == 0
                    ? itemList(items.unBoughtItems)
                    : this.index == 1
                        ? itemList(items.boughtItems)
                        : itemList(items.items
                            .where((element) =>
                                (element.category1 ==
                                            items.categories[this.index - 2] ||
                                        element.category2 ==
                                            items.categories[this.index - 2]) &&
                                    !element.bought ||
                                element.bought)
                            .toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
