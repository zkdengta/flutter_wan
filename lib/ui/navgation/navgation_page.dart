import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/base/base_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_wan/base/base_widget.dart';
import 'package:flutter_wan/http/api_service.dart';
import 'package:flutter_wan/ui/common/webview_page.dart';
import 'package:flutter_wan/util/utils.dart';
import 'package:flutter_wan/model/navi_model.dart';

class NavigationPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return NavigationPageState();
  }

}

class NavigationPageState extends BaseWidgetState<NavigationPage>{

  List<NaviData> _naviTitles = new List();
  //listview控制器
  ScrollController _scrollController = ScrollController();
  bool showToTopBtn = false; //是否显示“返回到顶部”按钮


  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
    _getData();

    _scrollController.addListener(() {
      _scrollController.addListener(() {
        //当前位置是否超过屏幕高度
        if (_scrollController.offset < 200 && showToTopBtn) {
          setState(() {
            showToTopBtn = false;
          });
        } else if (_scrollController.offset >= 200 && showToTopBtn == false) {
          setState(() {
            showToTopBtn = true;
          });
        }
      });
    });
  }

  Future<Null> _getData() async {
    ApiService().getNaviList((NaviModel _naviData){
      if(_naviData.errorCode == 0){
        if(_naviData.data.length > 0){
          showContent();
          setState(() {
            _naviTitles = _naviData.data;
          });
        }else{
          showEmpty();
        }
      }else{
        Fluttertoast.showToast(msg: _naviData.errorMsg);
      }
    }, (DioError error){
      //发生错误
      print(error.response);
      showError();
    });
  }

  @override
  AppBar getAppBar() {
    // TODO: implement getAppBar
    return AppBar(
      title: Text("不显示"),
    );
  }

  @override
  Widget getContentWidget(BuildContext context) {
    // TODO: implement getContentWidget
    return Scaffold(
      body: RefreshIndicator(
        displacement: 15.0,
          child: _rightListView(context),
          onRefresh: _getData,
      ),
      floatingActionButton: !showToTopBtn?null:FloatingActionButton(
        child: Icon(Icons.arrow_upward),
        onPressed: (){
          _scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.ease);
        },
      ),
    );
  }

  Widget _rightListView(BuildContext context){
    return ListView.separated(
        itemBuilder: _renderContent,
        separatorBuilder: (BuildContext context,int index){
          return Container(
            height: 0.5,
            color: Colors.black26,
          );
        },
        controller: _scrollController,
        physics: new AlwaysScrollableScrollPhysics(),
        itemCount: _naviTitles.length
    );
  }

  Widget _renderContent(BuildContext context,int index){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              _naviTitles[index].name,
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF3D4E5F),
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: buildChildren(_naviTitles[index].articles),
          )
        ],
      ),
    );
  }

  Widget buildChildren(List<NaviArticle> children){
    List<Widget> titles = [];
    Widget content;

    for(NaviArticle item in children){
      titles.add(new InkWell(
        child: new Chip(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: Utils.getChipBgColor(item.title),
          label: new Text(item.title),
        ),
        onTap: (){
          Navigator.of(context).push(new MaterialPageRoute(builder: (content){
            return new WebViewPage(title: item.title, url: item.link);
          }));
        },
      ));
    }
    content = Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      alignment: WrapAlignment.start,
      children: titles,
    );

    return content;
  }

  @override
  void onClickErrorWidget() {
    // TODO: implement onClickErrorWidget
    showLoading();
    _getData();
  }
}