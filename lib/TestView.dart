import 'dart:collection';
// import 'dart:html';
import 'dart:math';

import 'package:FlutterMind/Foreground.dart';
import 'package:FlutterMind/utils/HitTestResult.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:FlutterMind/utils/DragUtil.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:FlutterMind/widgets/RootNodeWidget.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  String data = "";

  MyTextField(this.data);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((mag) {
      RenderBox box = context.findRenderObject();

       print("页面渲染完毕:" + box.size.toString());
    });
    return  Container(
      color: Colors.red,
      child:Text(data)

    );
  }
}

class TestView extends NodeWidgetBase {
  @override
  State<StatefulWidget> createState() {
    return TestViewState();
  }
}

class TestViewState extends State<TestView> {

  UniqueKey key = new UniqueKey();
  String data = "";

  @override
  Widget build(BuildContext context) {


    return new Scaffold(
      body: Container(
        // width: Utils.screenSize().width,
        // height: Utils.screenSize().height,
        child:

          Container(
            child: Column(children: [
              MyTextField(data),
              TextField(
                onChanged: (msg) {
                  this.data  = msg;
                  setState(() {

                                    });
                },
              )

            ],)

        )));
  }
}