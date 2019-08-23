import 'package:flutter/material.dart';
import 'package:flutter_wan/ui/common/webview_page.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AboutPageState();
  }
}

class AboutPageState extends State<AboutPage>{
  
  TextStyle textStyle = new TextStyle(
    color: Colors.blue,
    decoration: new TextDecoration.combine([TextDecoration.underline])
  );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("关于作者"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(35.0, 50.0, 35.0, 15.0),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              minRadius: 60.0,
              maxRadius: 60.0,
              backgroundImage: AssetImage('images/head.jpg'),
            ),
            Padding(padding: EdgeInsets.only(top: 30.0)),
            Text("基于Google Flutter的玩Android客户端"),
            GestureDetector(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                child: Row(
                  children: <Widget>[
                    Text("GitHub："),
                    Text(
                        "https://github.com/zkdengta/flutter_wan",
                      style: textStyle,
                    )
                  ],
                ),
              ),
              onTap: (){
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (ctx) {
                  return new WebViewPage(
                      title: "GitHub",
                      url: "https://github.com/zkdengta/flutter_wan");
                }));
              },
            ),
            Expanded(child: Container(),flex: 1,),
            Text(
              "本项目仅供学习使用，不得用作商业目的",
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}