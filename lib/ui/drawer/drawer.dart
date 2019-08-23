import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_wan/util/theme_util.dart';
import 'package:flutter_wan/util/utils.dart';
import 'package:flutter_wan/common/application.dart';
import 'package:flutter_wan/event/change_theme_event.dart';
import 'package:share/share.dart';
import 'package:flutter_wan/common/user.dart';
import 'package:flutter_wan/ui/drawer/pretty_page.dart';
import 'package:flutter_wan/ui/drawer/about_page.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPage createState() => new _DrawerPage();
}

class _DrawerPage extends State<DrawerPage>{

  bool isLogin = false;
  String username = "未登录";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: InkWell(
              child: Text(username,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),
              ),
              onTap: () {
                if(!isLogin){
//                  Navigator.of(context).push(new MaterialPageRoute(builder: (context){
//                    return new LogingPage();
//                  }));
                }
              },
            ),
            currentAccountPicture: InkWell(
              child: CircleAvatar(
                backgroundImage: AssetImage("images/head.jpg"),
              ),
              onTap:() {
                if(!isLogin) {
//                  Navigator.of(context).push(new MaterialPageRoute(builder: (context){
//                    return new LogingPage();
//                  }));
                 }
                 } ,
            ),
          ),
          ListTile(
            title: Text(
              '我的收藏',
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.collections,size: 22.0,),
            onTap: (){
              if(isLogin){

              }else{

              }
            },
          ),
          ListTile(
            title: Text(
              '常用网站',
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.web,size: 22.0,),
            onTap: (){

            },
          ),
          ListTile(
            title: Text(
              '主题',
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.settings,size: 22.0,),
            onTap: (){
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return new SimpleDialog(
                    title: Text("设置主题"),
                    children: ThemeUtils.supportColors.map((Color color){
                      return new SimpleDialogOption(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                          height: 35.0,
                          color: color,
                        ),
                        onPressed: (){
                          ThemeUtils.currentColorTheme = color;
                          Utils.setColorTheme(ThemeUtils.supportColors.indexOf(color));
                          changeColorTheme(color);
                          Navigator.of(context).pop();
                        },
                      );
                    }).toList(),
                  );
                }
              );
            },
          ),
          ListTile(
            title: Text(
              '分享',
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.share,size: 22.0,),
            onTap: (){
              Share.share(
                  '给你推荐一个特别好玩的应用玩安卓客户端，点击下载：https://github.com/zkdengta/flutter_wan'
              );
            },
          ),
          ListTile(
            title: Text(
              '妹子图',
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.directions_bike, size: 22.0),
            onTap: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new PrettyPage();
              }));
            },
          ),
          ListTile(
            title: Text(
              '关于作者',
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.info, size: 22.0),
            onTap: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new AboutPage();
              }));
            },
          ),
             logoutWidget()
        ],
      ),
    );
  }

  Widget logoutWidget() {
    if(User.singleton.userName != null){
      return ListTile(
        title: Text(
          '退出登录',
          textAlign: TextAlign.left,
        ),
        leading: Icon(Icons.power_settings_new,size: 22.0,),
        onTap: (){
          User.singleton.clearUserInfor();
          setState(() {
            isLogin = false;
            username = '未登录';
          });
        },
      );
    }else{
      return SizedBox(
        height: 0,
      );
    }
  }


  void changeColorTheme(Color color) {
    Application.eventBus.fire(new ChangeThemeEvent(color));
  }
}
