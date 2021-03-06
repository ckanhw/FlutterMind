import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/StyleManager.dart';
import 'package:FlutterMind/TreeNode.dart';
import 'package:FlutterMind/layout/Layout.dart';
import 'package:FlutterMind/layout/LayoutController.dart';
import 'package:FlutterMind/utils/HitTestResult.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:FlutterMind/utils/base.dart';
import 'package:flutter/material.dart';

import '../Node.dart';
import '../utils/DragUtil.dart';
import 'NodeWidget.dart';
import 'RootNodeWidget.dart';

class NodeWidgetBase extends StatefulWidget {
  Node node;
  // DragUtil drag_ = DragUtil();
  double scale_ = 1.0;
  double _fontSize;
  FontWeight _fontWeight;
  String _fontFamily;
  Color _bgColor;
  Style _style;
  Image image;
  String url;
  List<Widget> icons = List<Widget>();
  String _note;

  bool _dirty = true;
  State<NodeWidgetBase> state;
  Layout layout;

  NodeWidgetBase({
    Key key,
    this.node
  }) : super(key: key) {
    layout = LayoutController().newLayout(this);
    _style = Settings().defaultStyle();
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

  Offset posInScreen(Offset pos) {
    return MapController().posInScreen(pos);
  }

  void setAlpha(alpha) {

  }

  void setSelected(selected) {
  }

  void moveToPosition(Offset dst) {
    layout.moveToPosition(dst);
  }

  void moveByOffset(Offset offset) {
    layout.moveByOffset(offset);
  }

  // void SetScale(double scale) {
  //   if (scale_ == scale) {
  //     return;
  //   }
  //   double sdiff = scale - scale_;
  //   scale_ = scale;
  //   width = ScreenUtil.getDp(plain_text_node_width) * (scale_);
  //   height = ScreenUtil.getDp(plain_text_node_width) * (scale_);

  //   if (node.parent != null) {
  //     NodeWidgetBase parent = node.parent.widget();
  //     Offset parent_pos = parent.offset;
  //     Offset self_pos = offset;

  //     var newx = self_pos.dx + (self_pos.dx - parent_pos.dx) * sdiff;
  //     var newy = self_pos.dy + (self_pos.dy - parent_pos.dy) * sdiff;
  //     Log.v("self_pos = " + self_pos.toString()+", parent pos=" + parent_pos.toString());
  //     Log.v("sdiff = " + sdiff.toString());
  //     Log.v("new pos = " + Offset(newx, newy).toString());
  //     moveToPosition(Offset(newx, newy));
  //   }
  // }

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

  String get label => node.label;

  set label(String l) {
    node.label = l;
  }

  String get note => _note;

  set note(String l) {
    _note = l;
    repaint();
  }

  
  void set width(double width) {
    layout.width = width;
  }

  void set height(double height) {
    layout.height = height;
  }

  String styleName() {
    if (_style != null)
    return _style.name();

    return "????????????";
  }

  void setStyle(style) {
    _style = style;
    Log.e("setStyle " + style.bgColor().toString());
    repaint();
  }

  Style createStyleIfNotExists(bool create) {
    if (create) {
      _style = Style(null);
    }
    return _style;
  }

  double fontSize() {
    if (_style == null) {
      Style s = Settings().defaultStyle();
      return s.fontSize();
    }
    return _style.fontSize();
  }

  FontWeight fontWeight() {
    if (_style == null) {
      Style s = Settings().defaultStyle();
      return s.fontWeight();
    }
    return _style.fontWeight();
  }

  String fontFamily() {
    if (_style == null) {
      Style s = Settings().defaultStyle();
      return s.fontFamily();
    }
    return _style.fontFamily();
  }

  bool fontItalic() {
    if (_style == null) {
      Style s = Settings().defaultStyle();
      return s.fontIsItalic();
    }
    return _style.fontIsItalic();
  }

  bool fontUnderline() {
    if (_style == null) {
      Style s = Settings().defaultStyle();
      return s.fontHasUnderline();
    }
    return _style.fontHasUnderline();
  }

  TextAlign textAlign() {
    if (_style == null) {
      Style s = Settings().defaultStyle();
      return s.textAlign();
    }
    return _style.textAlign();
  }

  double scaleLevel() {
    Settings s = Settings();
    Log.e("s.default_font_family = " + s.scaleLevel.toString());
    return s.scaleLevel;
  }

  Color bgColor() {
    if (_style == null) {
      Style s = Settings().defaultStyle();
      return s.bgColor();
    }
    return _style.bgColor();
  }

  Color borderColor() {
    if (_style == null) {
      Style s = Settings().defaultStyle();
    Log.e("new border color " + s.nodeBorderColor().toString());
      return s.nodeBorderColor();
    }
    Log.e("new border color " + _style.nodeBorderColor().toString());
    return _style.nodeBorderColor();
  }

  void insertImg(img) {
    image = img;
    repaint();
  }

  void insertUrl(_url) {
    url = _url;
    repaint();
  }

  void insertIcon(String icon) {
    icons.add(Image(width:15,
                                height:15,
                                image: Image.asset(icon).image));
    repaint();
  }

  void onPanStart(detail) {
    Log.i("NodeWidgetBase onPanStart");
    // layout.onPanStart(detail);
  }

  void onPanUpdate(detail) {
    // layout.onPanUpdate(detail);
  }

  void onPanEnd(detail) {
    // layout.onPanEnd(detail);
  }

  void updateEdges() {}

  void addChild(Node node) {
    dynamic w = node.widget();
    Layout l = w.layout;
    layout.addChild(l, Direction.auto);
    setNeedsRepaint();
    repaint();
  }

  void removeChild(Node node) {
    dynamic w = node.widget();
    Layout l = w.layout;
    layout.removeChild(l);
    setNeedsRepaint();
    repaint();
  }

  void removeFromParent() {
    if (layout == null) {
      Log.e("removeFromParent layout is null");
      return;
    }

    layout.removeFromParent();
    setNeedsRepaint();
    repaint();
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
    setNeedsRepaint();
    repaint();
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
    setNeedsRepaint();
    repaint();
  }

  void attach() {
    layout.attach();
  }

  void detach() {
    layout.detach();
  }

  void clear() {
    layout.clear();
  }

  void setNeedsRepaint() {
    if (!_dirty) {
      _dirty = true;
    }
  }

  void repaint() {
    if (_dirty || true) {
      if (state != null && state.mounted) {
        state.setState(() {});
      }
      updateEdges();
      _dirty = false;
    }
  }

  void relayout() {
    layout.relayout();
  }
}