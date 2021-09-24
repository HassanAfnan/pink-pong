import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pink_pong/ball.dart';
import 'package:pink_pong/bat.dart';

enum Direction { up, down, left, right }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pink Pong',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  double width;
  double height;
  double posX = 0;
  double posY = 0;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;
  Animation<double> animation;
  AnimationController controller;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  double increment = 5;
  double randX = 1;
  double randY = 1;
  int score = 0;


  @override
  void initState() {
    posX = 0;
    posY = 0;
    controller = AnimationController(
      duration: const Duration(minutes: 10000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      safeSetState(() {
        (hDir == Direction.right)? posX += (increment * randX).round() : posX -= (increment * randX).round();
        (vDir == Direction.down)? posY += (increment * randX).round() : posY -= (increment * randX).round();
      });
      checkBorders();
    });
    controller.forward();
    super.initState();
  }

  void safeSetState(Function function) {
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  void checkBorders() {
    double diameter = 50;
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }
    if (posY >= height - diameter - batHeight && vDir == Direction.down) {
      if (posX >= (batPosition - diameter) && posX <= (batPosition + batWidth + diameter)) {
        vDir = Direction.up;
        randY = randomNumber();
        safeSetState(() {
          score++;
        });
      } else {
        controller.stop();
        showMessage(context);
      }
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randY = randomNumber();
    }
  }

  void moveBat(DragUpdateDetails update) {
    safeSetState(() {
      batPosition += update.delta.dx; });
  }

  double randomNumber() {
    //this is a number between 0.5 and 1.5;
    var ran = new Random();
    int myNum = ran.nextInt(101);
    return (50 + myNum) / 100;
  }

  void showMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Game Over'),
              content: Text('Would you like to play again?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    setState(() { posX = 0; posY = 0;
                    score = 0; });
                    Navigator.of(context).pop();
                    controller.repeat(); },
                ),
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                      Navigator.of(context).pop();
                      dispose();
                    },
                ),
              ]
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pink Pong"),
      ),
      body: LayoutBuilder(
        builder: (context,constrain){
          height = constrain.maxHeight;
          width = constrain.maxWidth;
          batWidth = width / 5;
          batHeight = height / 20;
          return Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                right: 24,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Score: ' + score.toString(),style: TextStyle(color: Colors.red,fontWeight: FontWeight.w900,fontSize: 20),),
                ),
              ),
              Positioned(
                  child: Ball(),
                  top: posY,
                  left: posX,
              ),
              Positioned(
                  bottom: 0,
                  left: batPosition,
                  child: GestureDetector(
                      onHorizontalDragUpdate: (DragUpdateDetails update)
                      => moveBat(update),
                      child: Bat(width: batWidth, height:batHeight))
              ),
            ], );
        },
      ),
    );
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
