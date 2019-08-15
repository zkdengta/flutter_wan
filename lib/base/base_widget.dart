import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseWidget extends StatefulWidget {
  BaseWidgetState baseWidgetState;

  @override
  BaseWidgetState createState(){
    baseWidgetState = getState();
    return baseWidgetState;
  }

  BaseWidgetState getState();
}

abstract class BaseWidgetState<T extends BaseWidget> extends State<T> {

  bool _isAppBarShow = true;//导航栏是否显示
  bool _isErrorWidgetShow = false;//错误信息是否显示
  String _errorContentMessage = "网络请求失败，请检查您的网络";
  String _errImgPath = "images/ic_error.png";
  bool _isLoadingWidgetShow = false;
  bool _isEmptyWidgetShow = false;
  String _emptyWidgetContent = "暂无数据~";
  String _emptyImgPath = "images/ic_empty.png";

  FontWeight _fontWidget = FontWeight.w600; //错误页面和空页面的字体粗度

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _getBaseAppBar(),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            getContentWidget(context),
            _getBaseErrorWidget(),
            _getBaseEmptyWidget(),
            _getBaseLoadingWidget(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  PreferredSizeWidget _getBaseAppBar() {
    return PreferredSize(
      child: Offstage(
        offstage: !_isAppBarShow,
        child: getAppBar(),
      ),
      preferredSize: Size.fromHeight(50.0),
    );
  }

  AppBar getAppBar();

  Widget getContentWidget(BuildContext context);

  Widget _getBaseErrorWidget() {
    return Offstage(
      offstage: !_isErrorWidgetShow,
      child: getErrorWidget(),
    );
  }

  ///暴露的错误页面方法，可以自己重写定制
  Widget getErrorWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 80.0),
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage(_errImgPath),
              width: 120.0,
              height: 120.0,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(_errorContentMessage,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: _fontWidget,
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
              child: OutlineButton(
                child: Text(
                  "重新加载",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: _fontWidget,
                  ),
                ),
                onPressed: () => {
                  onClickErrorWidget()
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///点击错误页面后展示内容
  void onClickErrorWidget();

  Widget _getBaseEmptyWidget() {
    return Offstage(
      offstage: !_isEmptyWidgetShow,
      child: getEmptyWidget(),
    );
  }

  Widget getEmptyWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 100.0),
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                color: Colors.black12,
                image: AssetImage(_emptyImgPath),
                width: 150.0,
                height: 150.0,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                child: Text(
                  _emptyWidgetContent,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: _fontWidget,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBaseLoadingWidget() {
    return Offstage(
      offstage: !_isLoadingWidgetShow,
      child: getLoadingWidget(),
    );
  }

  Widget getLoadingWidget() {
    return Center(
      child: CupertinoActivityIndicator(
        radius: 15.0,//值越大加载的图形越大
      ),
    );
  }

  ///设置错误提示信息
  void setErrorContent(String content) {
    if (content != null) {
      setState(() {
        _errorContentMessage = content;
      });
    }
  }

  ///设置导航栏隐藏或者显示
  void setAppBarVisible(bool isVisible) {
    setState(() {
      _isAppBarShow = isVisible;
    });
  }

  void showContent() {
    setState(() {
      _isEmptyWidgetShow = false;
      _isLoadingWidgetShow = false;
      _isErrorWidgetShow = false;
    });
  }

  void showLoading() {
    setState(() {
      _isEmptyWidgetShow = false;
      _isLoadingWidgetShow = true;
      _isErrorWidgetShow = false;
    });
  }

  void showEmpty() {
    setState(() {
      _isEmptyWidgetShow = true;
      _isLoadingWidgetShow = false;
      _isErrorWidgetShow = false;
    });
  }

  void showError() {
    setState(() {
      _isEmptyWidgetShow = false;
      _isLoadingWidgetShow = false;
      _isErrorWidgetShow = true;
    });
  }

  ///设置空页面内容
  void setEmptyWidgetContent(String content) {
    if (content != null) {
      setState(() {
        _emptyWidgetContent = content;
      });
    }
  }

  ///设置错误页面图片
  void setErrorImage(String imagePath) {
    if (imagePath != null) {
      setState(() {
        _errImgPath = imagePath;
      });
    }
  }

  ///设置空页面图片
  void setEmptyImage(String imagePath) {
    if (imagePath != null) {
      setState(() {
        _emptyImgPath = imagePath;
      });
    }
  }
}