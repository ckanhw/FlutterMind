import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/layout/Layout.dart';
import 'package:FlutterMind/layout/LayoutController.dart';
import 'package:FlutterMind/utils/HitTestResult.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:FlutterMind/widgets/PlaceHolderWidget.dart';
import 'package:flutter/material.dart';

import '../Node.dart';
import '../utils/DragUtil.dart';
import 'NodeWidget.dart';
import 'RootNodeWidget.dart';

class NodeWidgetBase extends StatefulWidget {
  Node node;
  // DragUtil drag_ = DragUtil();
  double scale_ = 1.0;

  State<NodeWidgetBase> state;
  Layout layout;

  NodeWidgetBase({
    Key key,
    this.node
  }) : super(key: key) {
    layout = LayoutController().newLayout(this);
  }

  static Widget create(node) {
    // Node n = node.clone(); // why clone? floating node need a differenct key
    var key = UniqueKey();
    if (node.type == NodeType.rootNode) {
      return RootNodeWidget(key:key, node:node);
    } else if (node.type == NodeType.plainText) {
      return NodeWidget(key:key, node:node);
    }
  }

  Widget clone() {
    NodeWidgetBase w = create(node);
    w.width = width;
    w.height = height;
    w.scale_ = scale_;
    w.layout.drag_ = layout.drag_.clone();
    return w;
  }

  void setAlpha(alpha) {

  }

  void setSelected(selected) {
  }

  void moveToPosition(Offset dst) {
    layout.drag_.moveToPosition(dst);
  }

  void SetScale(double scale) {
    if (scale_ == scale) {
      return;
    }
    double sdiff = scale - scale_;
    scale_ = scale;
    width = ScreenUtil.getDp(plain_text_node_width) * (scale_);
    height = ScreenUtil.getDp(plain_text_node_width) * (scale_);

    if (node.parent != null) {
      NodeWidgetBase parent = node.parent.widget();
      Offset parent_pos = parent.offset;
      Offset self_pos = offset;

      var newx = self_pos.dx + (self_pos.dx - parent_pos.dx) * sdiff;
      var newy = self_pos.dy + (self_pos.dy - parent_pos.dy) * sdiff;
      Log.v("self_pos = " + self_pos.toString()+", parent pos=" + parent_pos.toString());
      Log.v("sdiff = " + sdiff.toString());
      Log.v("new pos = " + Offset(newx, newy).toString());
      moveToPosition(Offset(newx, newy));
    }
  }

  // void SetSize(Size size) {
  //   width = size.width;
  //   height = size.height;
  // }

  Offset center() {
    return offset.translate(width / 2, height / 2);
  }

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }

  static NodeWidgetBase ToNodeWidgetBase(w) {
    if (w is NodeWidgetBase) {
      return w;
    }
    return null;
  }

  double get x => layout.x;
  double get y => layout.y;
  Offset get offset => Offset(x, y);

  double get width => layout.width;
  double get height => layout.height;

  void set width(double width) {
    layout.width = width;
  }

  void set height(double height) {
    layout.height = height;
  }

  double fontSize() {
    // TODO：affected by scale
    Settings s = Settings();
    return s.default_font_size;
  }

  FontWeight fontWeight() {
    Settings s = Settings();
    return s.default_font_weight ? FontWeight.bold : FontWeight.normal;
  }

  String fontFamily() {
    Settings s = Settings();
    Log.e("s.default_font_family = " + s.default_font_family);
    return s.default_font_family;
  }

  void onPanStart(detail) {
    Log.i("NodeWidgetBase onPanStart");
    layout.onPanStart(detail);
  }

  void onPanUpdate(detail) {
    layout.onPanUpdate(detail);
  }

  void onPanEnd(detail) {
    layout.onPanEnd(detail);
  }

  void updateEdges() {}
  void addChild(Node node, {Direction direction = Direction.auto}) {
    dynamic w = node.widget();
    Layout l = w.layout;
    layout.addChild(l, direction:direction);
    updateEdges();
  }

  void removeChild(Node node) {
    dynamic w = node.widget();
    Layout l = w.layout;
    layout.removeChild(l);
    updateEdges();
  }

  void removeFromParent() {
    if (layout == null) {
      Log.e("removeFromParent layout is null");
      return;
    }

    layout.removeFromParent();
    updateEdges();
  }

  void insertBefore(node, target) {
    Log.e("NodeWidgetBase insertBefore " + target.hashCode.toString());
    if (layout == null) {
      Log.e("NodeWidgetBase insertBefore layout is null");
      return;
    }

    dynamic w1 = node.widget();
    Layout l1 = w1.layout;

    dynamic w2 = target.widget();
    Layout l2 = w2.layout;
    layout.insertBefore(l1, l2);
    updateEdges();
  }

  void insertAfter(node, target) {
    Log.e("NodeWidgetBase insertAfter " + target.hashCode.toString());
    if (layout == null) {
      Log.e("NodeWidgetBase insertAfter layout is null");
      return;
    }

    dynamic w1 = node.widget();
    Layout l1 = w1.layout;

    dynamic w2 = target.widget();
    Layout l2 = w2.layout;
    layout.insertAfter(l1, l2);
    updateEdges();
  }

  void repaint() {
    state?.setState(() {});
  }

  void relayout() {
    layout.relayout();
  }
}