import 'package:flutter/material.dart';
import 'package:one/widget/ZoomInOffset.dart';

class Model extends StatefulWidget {
  final double left; //距离左边位置 弹窗的x轴定位
  final double top; //距离上面位置 弹窗的y轴定位
  final bool otherClose; //点击背景关闭页面
  final Widget child; //传入弹窗的样式
  final Function fun; // 把关闭的函数返回给父组件 参考vue的$emit
  final Offset offset; // 弹窗动画的起点

  Model({
    @required this.child,
    this.left = 0,
    this.top = 0,
    this.otherClose = false,
    this.fun,
    this.offset,
  });

  @override
  _ModelState createState() => _ModelState();
}

class _ModelState extends State<Model> {
  AnimationController animateController;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Positioned(
            child: GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
              ),
              onTap: () async {
                if (widget.otherClose) {
                } else {
                  closeModel();
                }
              },
            ),
          ),
          Positioned(
            /// 这个是弹窗动画
            child: ZoomInOffset(
              duration: Duration(milliseconds: 180),
              offset: widget.offset,
              controller: (controller) {
                animateController = controller;
                widget.fun(closeModel);
              },
              child: widget.child,
            ),
            left: widget.left,
            top: widget.top,
          ),
        ],
      ),
    );
  }

  ///关闭页面动画
  Future closeModel() async {
    await animateController.reverse();
    Navigator.pop(context);
  }
}
