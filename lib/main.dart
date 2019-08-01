import 'package:flutter/material.dart';
import 'package:flutter_wan/util/theme_util.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'loading.dart';
import 'splash_screen.dart';
import 'app.dart';
import 'package:flutter_wan/event/change_theme_event.dart';
import 'package:flutter_wan/util/utils.dart';
import 'package:flutter_wan/common/application.dart';
import 'package:flutter_wan/common/user.dart';

void main() {
  getLoginInfo();
  runApp(MyApp());
  if(Platform.isAndroid){
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle();
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  }
}

Future<Null> getLoginInfo() async {
  User.singleton.getUserInfo();
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp>{

  Color themeColor = ThemeUtils.currentColorTheme;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utils.getColorThemeIndex().then((index){
      if(index != null){
        ThemeUtils.currentColorTheme = ThemeUtils.supportColors[index];
        Application.eventBus.fire(new ChangeThemeEvent(ThemeUtils.supportColors[index]));
      }
    });

    Application.eventBus.on<ChangeThemeEvent>().listen((event){
      setState(() {
        themeColor = event.color;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "玩Android",
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          primaryColor:themeColor,
          brightness: Brightness.light,
      ),
      routes: <String,WidgetBuilder>{
        "app":(BuildContext context) => new App(),
        "splash":(BuildContext context) => new SplashScreen(),
      },
      home: new LoadingPage(),
    );
  }

}