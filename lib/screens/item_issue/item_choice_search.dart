import 'package:flutter/material.dart';
class ItemSearchScreen extends StatefulWidget {
  const ItemSearchScreen({Key? key}) : super(key: key);

  @override
  _ItemSearchScreenState createState() => _ItemSearchScreenState();
}

class _ItemSearchScreenState extends State<ItemSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Item Search Screen"),
      ),
    );
  }
}
