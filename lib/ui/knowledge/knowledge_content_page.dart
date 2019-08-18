import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_wan/base/base_widget.dart';
import 'package:flutter_wan/http/api_service.dart';
import 'package:flutter_wan/model/system_tree_model.dart';
import 'package:flutter_wan/ui/common/webview_page.dart';
import 'package:flutter_wan/model/system_tree_content_model.dart';

class KnowledgeContentPage extends StatefulWidget {
  SystemTreeData data;


  KnowledgeContentPage(ValueKey<SystemTreeData>key):super(key:key){
    this.data = key.value;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return KnowledgeContentPageState();
  }

}

class KnowledgeContentPageState extends State<KnowledgeContentPage> with TickerProviderStateMixin{

  SystemTreeData _datas;
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _datas = widget.data;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController = new TabController(length: _datas.children.length, vsync: this);
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text(_datas.name),
        bottom: new TabBar(
          indicatorColor: Colors.white,
            labelStyle: TextStyle(fontSize: 16.0),
            unselectedLabelStyle: TextStyle(fontSize: 16.0),
            controller: _tabController,
            isScrollable: true,
            tabs:_datas.children.map((SystemTreeChild item){
              return Tab(
                text: item.name,
              );
            }).toList(),
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: _datas.children.map((item){
            return NewsList(item.id);
          }).toList(),
      ),
    );
  }
}
//知识体系文章列表
class NewsList extends BaseWidget {
  final int id;

  NewsList(this.id);

  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return _NewsListState();
  }
}

class _NewsListState extends BaseWidgetState<NewsList>{
  List<SystemTreeContentChild> _datas = new List();
  ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 0;

  @override
  void initState() {
    setAppBarVisible(false);
    showLoading();
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }
    });
  }

  Future<Null> getData() async {
    _page = 0;
    int _id = widget.id;

    ApiService().getSystemTreeContent( (SystemTreeContentModel _systemTreeContentModel) {
      if (_systemTreeContentModel.errorCode == 0) {
        //成功
        if (_systemTreeContentModel.data.datas.length > 0) {
          //有数据
          showContent();
          setState(() {
            _datas = _systemTreeContentModel.data.datas;
          });
        } else {
          //数据为空
          showEmpty();
        }
      } else {
        Fluttertoast.showToast(msg: _systemTreeContentModel.errorMsg);
      }
    }, (DioError error) {
      //发生错误
      print(error.response);
      showError();
      }, _page, _id);
  }

  Future<Null> _getMore() async {
    _page++;
    int _id = widget.id;

    ApiService().getSystemTreeContent(
            (SystemTreeContentModel _systemTreeContentModel) {

          if (_systemTreeContentModel.errorCode == 0) {
            //成功
            if (_systemTreeContentModel.data.datas.length > 0) {
              //有数据
              showContent();
              setState(() {
                _datas.addAll(_systemTreeContentModel.data.datas);
              });
            } else {
              //数据为空
              Fluttertoast.showToast(msg: "没有更多数据了");
            }
          } else {
            Fluttertoast.showToast(msg: _systemTreeContentModel.errorMsg);
          }
        },(DioError error) {
      //发生错误
      print(error.response);
      showError();
    }, _page, _id);
  }


  @override
  AppBar getAppBar() {
    // TODO: implement getAppBar
    return new AppBar(
      title: Text("不显示"),
    );
  }

  @override
  Widget getContentWidget(BuildContext context) {
    // TODO: implement getContentWidget
    return RefreshIndicator(
        child: ListView.separated(
            physics: new AlwaysScrollableScrollPhysics(),
            itemBuilder: _renderRow,
            controller: _scrollController,
            separatorBuilder: (BuildContext context, int index){
              return Container(
                height: 0.5,
                color: Colors.black26,
              );
            },
            itemCount: _datas.length + 1,
        ),
        onRefresh: getData,
    );
  }

  @override
  void onClickErrorWidget() {
    // TODO: implement onClickErrorWidget
    showLoading();
    getData();
  }

  Widget _renderRow(BuildContext context, int index) {
    if(index < _datas.length){
      return InkWell(
        child: Container(
          child: _newsRow(_datas[index]),
        ),
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return new WebViewPage(
                title: _datas[index].title, url: _datas[index].link);
          }));
        },
      );
    }
  }

  Widget _newsRow(SystemTreeContentChild data) {
    return new Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  data.author,
                  style: TextStyle(fontSize: 12.0,color: Colors.grey),
                ),
                new Expanded(
                    child: new Text(
                      data.niceDate,
                      style: TextStyle(fontSize: 12.0,color: Colors.grey),
                      textAlign: TextAlign.right,
                    ),
                ),
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    data.title,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: const Color(0xFF3D4E5F),
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
            child: Row(
              children: <Widget>[
                Text(
                  data.superChapterName,
                  style: TextStyle(fontSize: 12.0,color: Colors.grey),
                ),
                Text(
                  "/"+data.chapterName,
                  style: TextStyle(fontSize: 12.0,color:Colors.grey),
                  textAlign: TextAlign.right,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
