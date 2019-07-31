import 'package:flutter/material.dart';
import 'package:flutter_wan/util/theme_util.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'loading.dart';
import 'splash_screen.dart';
import 'app.dart';

void main() {
  runApp(MyApp());
  if(Platform.isAndroid){
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle();
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  }
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