import 'package:flutter/material.dart';
import 'package:flutter_wan/ui/drawer/drawer.dart';
import 'package:flutter_wan/ui/search/search.dart';
import 'package:flutter_wan/ui/home/home_page.dart';
import 'package:flutter_wan/ui/knowledge/knowledge_page.dart';
import 'package:flutter_wan/ui/tencent/tencent_page.dart';
import 'package:flutter_wan/ui/navgation/navgation_page.dart';
import 'package:flutter_wan/ui/project/project_page.dart';

//应用页面使用有状态Widget
class App extends StatefulWidget {
  App({Key key}):super(key : key);
  @override
  _AppSate createState() => new _AppSate();
}

class _AppSate extends State<App> {

  int _selectedIndex = 0; //当前选中项的索引
  final appBarTitles = ['玩Android', '体系', '公众号', '导航', "项目"];
  int elevation = 4;

  var pages = <Widget>[
    HomePage(),
    KnowledgePage(),
    TencentPage(),
    NavigationPage(),
    ProjectPage()
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope( //双击返回与界面退出提示
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: DrawerPage(),
        appBar: AppBar(
          title: new Text(appBarTitles[_selectedIndex]),
          bottom: null,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context){return new SearchPage();}
                    )
                );
              },
            )
          ],
        ),
        body: new IndexedStack(
          children: pages,
          index: _selectedIndex,
        ),
        //底部导航按钮 包含图标及文本
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.assignment), title: Text('体系')),
              BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text('公众号')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.navigation), title: Text('导航')),
              BottomNavigationBarItem(icon: Icon(Icons.book), title: Text('项目'))
            ],
          type: BottomNavigationBarType.fixed,//设置显示的模式
          currentIndex: _selectedIndex,//当前选中项的索引
          onTap: _onItemTapped,//选择按下处理
        ),
      ),
    );
  }


  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
      builder: (context) => new AlertDialog(
        title: new Text("提示"),
        content: new Text("确定退出应用吗？"),
        actions: <Widget>[
          new FlatButton(
              onPressed: () => Navigator.of(context).pop(false), 
              child: new Text("再看一会")
          ),
          new FlatButton(
              onPressed: () => Navigator.of(context).pop(true), 
              child: new Text("退出")
          )
        ],
      )
    )?? false;
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
      if(value == 2 || value == 4){
        elevation = 0;
      }else {
        elevation = 4;
      }
    });
  }
}