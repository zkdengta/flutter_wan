import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_wan/util/theme_util.dart';
import 'package:flutter_wan/widget/likebtn/like_button.dart';
import 'package:flutter_wan/http/api_service.dart';
import 'package:flutter_wan/model/base_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_wan/widget/likebtn/model.dart';

class WebViewPage extends StatefulWidget {
  String title;
  String url;
  int id;
  bool collect;

  WebViewPage({
    Key key,
    @required this.title,
    @required this.url,
    @required this.id,
    @required this.collect,
  }):super(key : key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new WebViewPageState();
  }

}

class WebViewPageState extends State<WebViewPage>{
  bool isLoad = true;
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  bool isLike = false;

  //新增收藏
  Future<Null> addCollect() async {
    ApiService().addWebsiteCollectionList((BaseModel _baseModel) {
      if (_baseModel.errorCode == 0) {
        //成功
        Fluttertoast.showToast(msg: "收藏成功！");
      } else {
        Fluttertoast.showToast(msg: _baseModel.errorMsg);
      }
    },widget.title,widget.url);
  }

  //取消收藏
  Future<Null> cancelCollect() async {
    ApiService().cancelWebsiteCollectionList((BaseModel _baseModel) {
      if (_baseModel.errorCode == 0) {
        //成功
        Fluttertoast.showToast(msg: "取消收藏！");
      } else {
        Fluttertoast.showToast(msg: _baseModel.errorMsg);
      }
    },widget.id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterWebViewPlugin.onStateChanged.listen((state){
      debugPrint("state:_" + state.type.toString());
      if(state.type == WebViewState.finishLoad){
        setState(() {
          isLoad = false;
        });
      }else if(state.type == WebViewState.startLoad){
        setState(() {
          isLoad = true;
        });
      }
    });
    if(widget.collect){
      setState(() {
        isLike = true;
      });

    }else{
      setState(() {
        isLike = false;
      });
    }

    print(widget.collect);
    print(isLike);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: WebviewScaffold(
        url: widget.url,
        appBar: new AppBar(
          elevation: 0.4,
          title: new Text(widget.title),
          bottom: new PreferredSize(
              child: isLoad ? new LinearProgressIndicator():
              new Divider(height: 1.0,color: ThemeUtils.currentColorTheme,),
              preferredSize: const Size.fromHeight(1.0),
          ),
          actions: <Widget>[
            LikeButton(
              width: 56.0,
              duration: Duration(milliseconds: 500),
              onIconClicked: (isLike){
                if(isLike){
                  cancelCollect();
                }else{
                  addCollect();
                }
                setState(() {
                  isLike = !isLike;
                });
              },
            ),
          ],
        ),
        withJavascript: true,
        withZoom: true,
        withLocalStorage: true,
      ),
    );
  }
}