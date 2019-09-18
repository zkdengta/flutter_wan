import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_wan/base/base_widget.dart';
import 'package:flutter_wan/model/article_model.dart';
import 'package:flutter_wan/ui/common/webview_page.dart';
import 'package:flutter_wan/http/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_wan/ui/home/banner.dart';

class HomePage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return HomePageState();
  }

}

class HomePageState extends BaseWidgetState<HomePage>{
  List<Article> _datas = new List();
  ScrollController _scrollController = ScrollController();
  bool showToTopBtn = false;//是否显示“返回到顶部”按钮
  int _page = 0;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAppBarVisible(false);
    showLoading();
    _getData();
    
    _scrollController.addListener((){
      //滑到了底部，加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }

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

  @override
  AppBar getAppBar() {
    // TODO: implement getAppBar
    return AppBar(
      title: Text("不显示"),
    );
  }
  
  Future<Null> _getData() async {
    _page = 0;
    ApiService().getArticleList((ArticleModel _articleModel){
      if (_articleModel.errorCode == 0) {
        //成功
        if (_articleModel.data.datas.length > 0) {
          //有数据
          showContent();
          setState(() {
            _datas.clear();
            _datas.addAll(_articleModel.data.datas);
          });
        } else {
          //数据为空
          showEmpty();
        }
      } else {
        Fluttertoast.showToast(msg: _articleModel.errorMsg);
      }
    }, (DioError error){
      //发生错误
      print(error.response);
      setState(() {
        showError();
      });
    }, _page);
  }

  //加载更多的数据
  Future<Null> _getMore() async {
    _page++;
    ApiService().getArticleList((ArticleModel _articleModel) {
      if (_articleModel.errorCode == 0) {
        //成功
        if (_articleModel.data.datas.length > 0) {
          //有数据
          showContent();
          setState(() {
            _datas.addAll(_articleModel.data.datas);
          });
        } else {
          //数据为空
          Fluttertoast.showToast(msg: "没有更多数据了");
        }
      } else {
        Fluttertoast.showToast(msg: _articleModel.errorMsg);
      }
    }, (DioError error) {
      //发生错误
      print(error.response);
      setState(() {
        showError();
      });
    }, _page);
  }

  @override
  Widget getContentWidget(BuildContext context) {
    // TODO: implement getContentWidget
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: _getData,
          child: ListView.separated(
              itemBuilder: _renderRow,
              physics: new AlwaysScrollableScrollPhysics(),
              separatorBuilder: (BuildContext context, int index){
                return Container(
                  height: 0.5,
                  color: Colors.black26,
                );
              },
              controller: _scrollController,
              //包含轮播图和加载更多
              itemCount: _datas.length + 2),
      ),
      floatingActionButton: !showToTopBtn ? null : FloatingActionButton(
        child: Icon(Icons.arrow_upward),
        onPressed: (){
          //返回到顶部时执行动画
          _scrollController.animateTo(.0,
              duration: Duration(milliseconds: 200), curve: Curves.ease);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onClickErrorWidget() {
    // TODO: implement onClickErrorWidget
    showLoading();
    _getData();
  }


  Widget _renderRow(BuildContext context, int index) {
    if (index == 0){
      return Container(
        height: 200.0,
        color: Colors.green,
        child: new BannerWidget(),
      );

    }

    if(index < _datas.length -1){
      return new InkWell(
        onTap: (){
          Navigator.of(context).push(new MaterialPageRoute(builder: (context){
            return new WebViewPage(
                title: _datas[index-1].title,
                url:  _datas[index-1].link,
                id: _datas[index-1].id,
                collect: _datas[index-1].collect,
            );
          }));
        },
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    _datas[index - 1].author,
                    style: TextStyle(fontSize: 12.0),
                    textAlign: TextAlign.left,
                  ),
                  Expanded(
                    child: Text(
                      _datas[index - 1].niceDate,
                      style: TextStyle(fontSize: 12.0),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _datas[index - 1].title,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3D4E5F),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _datas[index - 1].superChapterName,
                      style: TextStyle(fontSize: 12.0),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}