import 'package:dio/dio.dart';
import 'package:flutter_wan/http/dio_manager.dart';
import 'package:flutter_wan/http/api.dart';
import 'package:flutter_wan/model/hotword_model.dart';
import 'package:flutter_wan/common/user.dart';
import 'package:flutter_wan/model/hotword_result_model.dart';
import 'package:flutter_wan/model/article_model.dart';
import 'package:flutter_wan/model/banner_model.dart';
import 'package:flutter_wan/model/system_tree_model.dart';
import 'package:flutter_wan/model/system_tree_content_model.dart';
import 'package:flutter_wan/model/wx_article_content_model.dart';
import 'package:flutter_wan/model/wx_article_title_model.dart';
import 'package:flutter_wan/model/navi_model.dart';
import 'package:flutter_wan/model/projectlist_model.dart';
import 'package:flutter_wan/model/project_tree_model.dart';
import 'package:flutter_wan/model/pretty_model.dart';
import 'package:flutter_wan/model/common_websit_model.dart';
import 'package:flutter_wan/model/user_model.dart';
import 'package:flutter_wan/model/base_model.dart';
import 'package:flutter_wan/model/collection_model.dart';
import 'package:flutter_wan/model/website_collection_model.dart';

class ApiService{

  ///获取搜索热词
  void getSearchHotWord(Function callback) async {
    DioManager.singleton.dio
        .get(Api.SEARCH_HOT_WORD,options:_getOptions())
        .then((response){
          callback(HotwordModel.fromMap(response.data));
    });
  }

  /// 获取搜索结果
  void getSearchResult(Function callback,Function errorback,int page, String keyword) async{
    FormData formData = new FormData.from(
     {
       "k":keyword,
     }
    );
    DioManager.singleton.dio
        .post(Api.SEARCH_RESULT + "$page/json", data:formData,options:_getOptions())
    .then((response){
      callback(HotwordResultModel.fromMap(response.data));
    }).catchError((e){
      errorback(e);
    });
  }
  ///获取文章列表
  void getArticleList(Function callback,Function errorback,int page) async {
    DioManager.singleton.dio
        .get(Api.HOME_ARTICLE_LIST + "$page/json",options:_getOptions())
        .then((response){
          callback(ArticleModel(response.data));
    }).catchError((e){
      errorback(e);
    });
  }

  ///轮播图
  void getBanner(Function callback) async {
    DioManager.singleton.dio
        .get(Api.HOME_BANNER, options: _getOptions())
        .then((response) {
      callback(BannerModel(response.data));
    });
  }

  /// 获取知识体系列表
  void getSystemTree(Function callback,Function errorback){
    DioManager.singleton.dio
        .get(Api.SYSTEM_TREE,options:_getOptions())
        .then((response){
          callback(SystemTreeModel(response.data));
    }).catchError((e){
      errorback(e);
    });
  }

  /// 获取知识体系列表详情
  void getSystemTreeContent(Function callback, Function errorback,int _page, int _id) async {
    DioManager.singleton.dio
        .get(Api.SYSTEM_TREE_CONTENT + "$_page/json?cid=$_id",options:_getOptions())
        .then((response){
          callback(SystemTreeContentModel(response.data));
    }).catchError((e){
      errorback(e);
    });
  }

  /// 获取公众号文章
  void getWxArticleList(Function callback, int _id, int _page) async {
    DioManager.singleton.dio
        .get(Api.WX_ARTICLE_LIST + "$_id/$_page/json", options: _getOptions())
        .then((response) {
      callback(WxArticleContentModel(response.data));
    });
  }

  /// 获取公众号名称
  void getWxList(Function callback, Function errorback) async {
    DioManager.singleton.dio
        .get(Api.WX_LIST, options: _getOptions())
        .then((response) {
      callback(WxArticleTitleModel(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取导航列表数据
  void getNaviList(Function callback, Function errorback) async {
    DioManager.singleton.dio
        .get(Api.NAVI_LIST, options: _getOptions())
        .then((response) {
      callback(NaviModel(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取项目分类
  void getProjectTree(Function callback,Function errorback) async {
    DioManager.singleton.dio
        .get(Api.PROJECT_TREE, options: _getOptions())
        .then((response) {
      callback(ProjectTreeModel(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取项目列表
  void getProjectList(Function callback, int _page, int _id) async {
    DioManager.singleton.dio
        .get(Api.PROJECT_LIST + "$_page/json?cid=$_id", options: _getOptions())
        .then((response) {
      callback(ProjectTreeListModel(response.data));
    });
  }

  ///妹子图
  void getPrettyGirl(Function callback, int _page) async {
    DioManager.singleton.dio
        .get("http://gank.io/api/data/福利/10/" + "$_page")
        .then((response) {
      callback(PrettyModel.fromMap(response.data));
    });
  }

  ///常用网站
  void getCommonWebsite(Function callback, Function errorback) async {
    DioManager.singleton.dio
        .get(Api.COMMON_WEBSITE, options: _getOptions())
        .then((response) {
      callback(CommonWebsitModel.fromMap(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 登录
  void login(Function callback, String _username, String _password) async {
    FormData formData =
    new FormData.from({"username": _username, "password": _password});
    DioManager.singleton.dio
        .post(Api.USER_LOGIN, data: formData, options: _getOptions())
        .then((response) {
      callback(UserModel(response.data), response);
    });
  }

  /// 注册
  void register(Function callback, String _username, String _password) async {
    FormData formData = new FormData.from({
      "username": _username,
      "password": _password,
      "repassword": _password
    });
    DioManager.singleton.dio
        .post(Api.USER_REGISTER, data: formData, options: null)
        .then((response) {
      print(response.toString());
      callback(UserModel(response.data));
    });
  }

  /// 获取收藏列表
  void getCollectionList(
      Function callback, Function errorback, int _page) async {
    DioManager.singleton.dio
        .get(Api.COLLECTION_LIST + "$_page/json", options: _getOptions())
        .then((response) {
      callback(CollectionModel(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 我的收藏-取消收藏
  void cancelCollection(
      Function callback, Function errorback, int _id, int _originId) async {
    FormData formData = new FormData.from({"originId": _originId});
    DioManager.singleton.dio
        .post(Api.CANCEL_COLLECTION + "$_id/json",
        data: formData, options: _getOptions())
        .then((response) {
      callback(BaseModel(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取网络收藏列表
  void getWebsiteCollectionList(
      Function callback, Function errorback) async {
    DioManager.singleton.dio
        .get(Api.WEBSITE_COLLECTION_LIST , options: _getOptions())
        .then((response) {
      callback(WebsiteCollectionModel(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 新增网站收藏
  void addWebsiteCollectionList(Function callback, String name,String link) async {
    FormData formData = new FormData.from({
      "name": name,
      "link": link,
    });
    DioManager.singleton.dio
        .post(Api.ADD_WEBSITE_COLLECTION,
        data: formData, options: _getOptions())
        .then((response) {
      callback(BaseModel(response.data));
    });
  }


  /// 取消网站收藏
  void cancelWebsiteCollectionList(Function callback, int _id) async {
    FormData formData = new FormData.from({
      "id": _id,
    });
    DioManager.singleton.dio
        .post(Api.CANCEL_WEBSITE_COLLECTION,
        data: formData, options: _getOptions())
        .then((response) {
      callback(BaseModel(response.data));
    });
  }



  Options _getOptions() {
    Map<String, String> map = new Map();
    List<String> cookies = User().cookie;
    map["Cookie"] = cookies.toString();
    return Options(headers: map);
  }
}