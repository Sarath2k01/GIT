import 'package:flutter/material.dart';

class MongoDBScreen extends StatefulWidget {
  const MongoDBScreen({ Key? key }) : super(key: key);

  @override
  _MongoDBScreenState createState() => _MongoDBScreenState();
}

class _MongoDBScreenState extends State<MongoDBScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.redAccent,
      height: size.height,
      width: size.width,
    );
  }
}