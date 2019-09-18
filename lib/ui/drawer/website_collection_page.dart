import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_wan/base/base_widget.dart';
import 'package:flutter_wan/http/api_service.dart';
import 'package:flutter_wan/model/base_model.dart';
import 'package:flutter_wan/model/website_collection_model.dart';
import 'package:flutter_wan/ui/common/webview_page.dart';

class WebSiteCollectionPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return CollectionPageState();
  }

}

class CollectionPageState extends BaseWidgetState<WebSiteCollectionPage>{

  List<WebsiteCollectionData> _datas = new List();
  ScrollController _scrollController = ScrollController();

  bool showToTopBtn = false;

  Future<Null> getData() async {
    ApiService().getWebsiteCollectionList((
        WebsiteCollectionModel _collectionModel,
        ) {
      if (_collectionModel.errorCode==0) {//成功
        if (_collectionModel.data.length > 0) {//有数据
          showContent();
          setState(() {
            _datas.clear();
            _datas.addAll(_collectionModel.data);
          });
        } else {//数据为空
          showEmpty();
        }
      }else{
        Fluttertoast.showToast(msg: _collectionModel.errorMsg);
      }
    }, (DioError error) {//发生错误
      print(error.response);
      setState(() {
        showError();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    showLoading();
    getData();

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
  }

  Future<Null> _cancelCollection(int index, int id) async{
    ApiService().cancelWebsiteCollectionList((BaseModel _baseModel){
      if(_baseModel.errorCode == 0){
        _datas.removeAt(index);
      }
      Scaffold.of(context).showSnackBar(new SnackBar(
          content: Text("移除成功！"),
      ));
      setState(() {

      });
    }, id);
  }

  @override
  AppBar getAppBar() {
    // TODO: implement getAppBar
    return AppBar(
      title: Text("我的收藏"),
      elevation: 0.4,
    );
  }

  @override
  Widget getContentWidget(BuildContext context) {
    // TODO: implement getContentWidget
    return Scaffold(
      body: RefreshIndicator(
        displacement: 15.0,
          child: ListView.separated(
            //普通项
            itemBuilder: _renderRow,
            //插入项
            separatorBuilder: (BuildContext context,int index){
              return Container(
                height: 0.5,
                color: Colors.black26,
              );
            },
            controller: _scrollController,
            itemCount: _datas.length + 1,
          ),
          onRefresh: getData,
      ),
      floatingActionButton: !showToTopBtn ? null : FloatingActionButton(
        child: Icon(Icons.arrow_upward),
        onPressed: (){
          _scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.ease);
        },
      ),
    );
  }

  Widget _renderRow(BuildContext context, int index){
    if(index < _datas.length){
      return _itemView(context,index);
    }
    return null;
  }

  Widget _itemView(BuildContext context, int index) {
    return InkWell(
      child: _slideRpw(index, _datas[index]),
      onTap: (){
        Navigator.of(context).push(new MaterialPageRoute(builder: (context){
          return WebViewPage(
            title: _datas[index].name,
            url: _datas[index].link,
            id: _datas[index].id,
            collect: true,
          );
        }));
      },
    );
  }

  Widget _slideRpw(int index, WebsiteCollectionData data) {
    return Slidable(
      delegate: new SlidableBehindDelegate(),
      actionExtentRatio: 0.25,
      child: _newsRow(data),
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: '取消收藏',
            color: Colors.red,
            icon: Icons.delete,
          onTap: (){
            _cancelCollection(index, data.id);
          },
        )
      ],
    );
  }

  Widget _newsRow(WebsiteCollectionData data) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  data.name,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3D4E5F),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        new Container(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                data.link,
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void onClickErrorWidget() {
    // TODO: implement onClickErrorWidget
    showLoading();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

}