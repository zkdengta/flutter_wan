import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/base/base_widget.dart';

class NavigationPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return NavigationPageState();
  }

}

class NavigationPageState extends BaseWidgetState<NavigationPage>{
  @override
  AppBar getAppBar() {
    // TODO: implement getAppBar
    return null;
  }

  @override
  Widget getContentWidget(BuildContext context) {
    // TODO: implement getContentWidget
    return null;
  }

  @override
  void onClickErrorWidget() {
    // TODO: implement onClickErrorWidget
  }
}