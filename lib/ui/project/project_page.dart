import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/base/base_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_wan/common/application.dart';
import 'package:flutter_wan/event/change_theme_event.dart';
import 'package:flutter_wan/http/api_service.dart';
import 'package:flutter_wan/ui/common/webview_page.dart';
import 'package:flutter_wan/util/theme_util.dart';
import 'package:flutter_wan/model/project_tree_model.dart';
import 'package:flutter_wan/model/projectlist_model.dart';

class ProjectPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return ProjectPageState();
  }

}

class ProjectPageState extends BaseWidgetState<ProjectPage> with TickerProviderStateMixin{

  Color themeColor = ThemeUtils.currentColorTheme;
  List<ProjectTreeData> _datas = new List();
  TabController _tabController;

  Future<Null> _getData() async {
    ApiService().getProjectTree((ProjectTreeModel _projectTreeModel) {

      if (_projectTreeModel.errorCode == 0) {
        //成功
        if (_projectTreeModel.data.length > 0) {
          //有数据
          showContent();
          setState(() {
            _datas = _projectTreeModel.data;
          });
        } else {
          //数据为空
          showEmpty();
        }
      } else {
        Fluttertoast.showToast(msg: _projectTreeModel.errorMsg);
      }

    }, (DioError error) {
      //发生错误
      print(error.response);
      showError();
    });
  }

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
    _getData();
    Application.eventBus.on<ChangeThemeEvent>().listen((event) {
      setState(() {
        themeColor = event.color;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    super.dispose();
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
    _tabController = new TabController(
        length: _datas.length,
        vsync: this
    );
    // TODO: implement getContentWidget
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: themeColor,
            height: 48.0,
            child: TabBar(
              indicatorColor: Colors.white,
                labelStyle: TextStyle(fontSize: 16.0),
                unselectedLabelStyle: TextStyle(fontSize: 16.0),
                controller: _tabController,
                tabs: _datas.map((ProjectTreeData item){
                  return Tab(text: item.name,);
                }).toList(),
              isScrollable: true,
            ),
          ),
          Expanded(
              child: TabBarView(
                controller: _tabController,
                  children: _datas.map((item){
                    return ProjectList(item.id);
                  }).toList(),
              )
          )
        ],
      ),
    );
  }

  @override
  void onClickErrorWidget() {
    // TODO: implement onClickErrorWidget
    showLoading();
    _getData();
  }
}

class ProjectList extends StatefulWidget{
  final int id;

  ProjectList(this.id);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ProjectListState();
  }
}

class _ProjectListState extends State<ProjectList>{
  List<ProjectTreeListDatas> _datas = new List();
  ScrollController _scrollController = ScrollController();
  int _page = 1;

  bool showToTopBtn = false;

  Future<Null> _getData() async {
    _page = 1;
    int _id = widget.id;
    ApiService().getProjectList((ProjectTreeListModel projectTreeListModel) {
      setState(() {
        _datas = projectTreeListModel.data.datas;
      });
    }, _page, _id);
  }

  Future<Null> _getMore() async {
    _page++;
    int _id = widget.id;
    ApiService().getProjectList((ProjectTreeListModel projectTreeListModel) {
      setState(() {
        _datas.addAll(projectTreeListModel.data.datas);
      });
    }, _page, _id);
  }

  @override
  void initState() {
    super.initState();
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }
    });

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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: RefreshIndicator(
        displacement: 15.0,
        onRefresh: _getData,
          child: ListView.separated(
              itemBuilder: _renderRow,
              physics: new AlwaysScrollableScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  height: 0.5,
                  color: Colors.black26,
                );
              },
              controller: _scrollController,
              itemCount: _datas.length + 1
          ),
      ),
      floatingActionButton: !showToTopBtn ? null : FloatingActionButton(
          child: Icon(Icons.arrow_upward),
          onPressed: () {
            //返回到顶部时执行动画
            _scrollController.animateTo(.0,
                duration: Duration(milliseconds: 200),
                curve: Curves.ease
            );
          }
      ),
    );
  }

  Widget _renderRow(BuildContext context,int index){
    if(index < _datas.length){
      return new InkWell(
        onTap: (){
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return new WebViewPage(
                title: _datas[index].title, url: _datas[index].link);
          }));
        },
        child: Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                                  _datas[index].title,
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
                        padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                _datas[index].desc,
                                style: TextStyle(fontSize: 12.0, color: Colors.grey),
                                textAlign: TextAlign.left,
                                maxLines: 3,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _datas[index].author,
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              _datas[index].niceDate,
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),

                          ],
                        ),
                      )
                    ],
                  )
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: Image.network(
                    _datas[index].envelopePic,
                    width: 80,
                    height: 120,
                    fit: BoxFit.fill,
                  )),
            ],
          ),
        ),
      );
    }
    return null;
  }
}