import 'package:flutter/material.dart';
import 'package:one/widget/Model.dart';
import 'package:one/widget/Popup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///给获取详细信息的widget设置一个key
  GlobalKey iconkey = GlobalKey();

  ///获取位置，给后续弹窗设置位置
  Offset iconOffset;

  ///获取size 后续计算弹出位置
  Size iconSize;

  ///接受弹窗类构造成功传递来的关闭参数
  Function closeModel;

  @override
  Widget build(BuildContext context) {
    ///等待widget初始化完成
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      ///通过key获取到widget的位置
      RenderBox box = iconkey.currentContext.findRenderObject();

      ///获取widget的高宽
      iconSize = box.size;

      ///获取位置
      iconOffset = box.localToGlobal(Offset.zero);
    });

    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                key: iconkey,
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () {
                  showModel(context);
                },
              ),
            ],
          ),
          body: Column(
            children: [],
          ),
        ),
      ),
    );
  }

  ///播放动画
  void showModel(BuildContext context) {
    /// 设置传入弹窗的高宽
    double _width = 130;
    double _height = 230;

    Navigator.push(
      context,
      Popup(
        child: Model(
          left: iconOffset.dx - _width + iconSize.width / 1.2,
          top: iconOffset.dy + iconSize.height / 1.3,
          offset: Offset(_width / 2, -_height / 2),
          child: Container(
            width: _width,
            height: _height,
            child: buildMenu(),
          ),
          fun: (close) {
            closeModel = close;
          },
        ),
      ),
    );
  }

  ///构造传入的widget
  Widget buildMenu() {
    ///构造List
    List _list = [1, 2, 3, 4, 5];

    return Container(
      height: 160,
      width: 230,
      child: Stack(
        children: [
          Positioned(
            right: 4,
            top: 17,
            child: Container(
              width: 20,
              height: 20,
              transform: Matrix4.rotationZ(45 * 3.14 / 180),
              decoration: BoxDecoration(
                color: Color.fromRGBO(46, 53, 61, 1),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),

          ///菜单内容
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: 20,
                bottom: 20,
                left: 10,
                right: 10,
              ),
              width: 130,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(46, 53, 61, 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _list
                    .map<Widget>((e) => InkWell(
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              '这应该是选项${e.toString()}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          onTap: () async {
                            print('这是点击了选项${e.toString()}');
                            await Future.delayed(Duration(milliseconds: 500))
                                .then((value) => print('开始'));
                            await closeModel();
                            print('结束');
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
