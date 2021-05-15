import 'package:flutter/material.dart';

class ZoomInOffset extends StatefulWidget {
  final Key key;
  final Widget child;
  final Duration duration;
  final Duration delay;

  ///把控制器通过函数传递出去，可以在父组件进行控制
  final Function(AnimationController) controller;
  final bool manualTrigger;
  final bool animate;
  final double from;

  ///这是我自己写的 起点
  final Offset offset;

  ZoomInOffset(
      {this.key,
      this.child,
      this.duration = const Duration(milliseconds: 500),
      this.delay = const Duration(milliseconds: 0),
      this.controller,
      this.manualTrigger = false,
      this.animate = true,
      this.offset,
      this.from = 1.0})
      : super(key: key) {
    if (manualTrigger == true && controller == null) {
      throw FlutterError('If you want to use manualTrigger:true, \n\n'
          'Then you must provide the controller property, that is a callback like:\n\n'
          ' ( controller: AnimationController) => yourController = controller \n\n');
    }
  }

  @override
  _ZoomInState createState() => _ZoomInState();
}

/// State class, where the magic happens
class _ZoomInState extends State<ZoomInOffset>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  bool disposed = false;
  Animation<double> fade;
  Animation<double> opacity;

  @override
  void dispose() async {
    disposed = true;
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: widget.duration, vsync: this);
    fade = Tween(begin: 0.0, end: widget.from)
        .animate(CurvedAnimation(curve: Curves.easeOut, parent: controller));

    opacity = Tween<double>(begin: 0.0, end: 1)
        .animate(CurvedAnimation(parent: controller, curve: Interval(0, 0.65)));

    if (!widget.manualTrigger && widget.animate) {
      Future.delayed(widget.delay, () {
        if (!disposed) {
          controller?.forward();
        }
      });
    }

    if (widget.controller is Function) {
      widget.controller(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate && widget.delay.inMilliseconds == 0) {
      controller?.forward();
    }

    return AnimatedBuilder(
      animation: fade,
      builder: (BuildContext context, Widget child) {
        ///  这个transform有origin的可选构造参数，我们可以手动添加
        return Transform.scale(
          origin: widget.offset,
          scale: fade.value,
          child: Opacity(
            opacity: opacity.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}
