import 'package:flutter/material.dart';

class Bat extends StatefulWidget {
  final double height;
  final double width;

  const Bat({Key key, this.height, this.width}) : super(key: key);
  @override
  _BatState createState() => _BatState();
}

class _BatState extends State<Bat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: new BoxDecoration(
        color: Colors.orange,
      ),
    );
  }
}
