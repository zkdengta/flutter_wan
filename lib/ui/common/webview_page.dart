import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_wan/util/theme_util.dart';

class WebViewPage extends StatefulWidget {
  String title;
  String url;


  WebViewPage({
    Key key,
    @required this.title,
     @required this.url,
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
        ),
        withJavascript: true,
        withZoom: true,
        withLocalStorage: true,
      ),
    );
  }
}