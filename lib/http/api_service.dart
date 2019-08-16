import 'package:dio/dio.dart';
import 'package:flutter_wan/http/dio_manager.dart';
import 'package:flutter_wan/http/api.dart';
import 'package:flutter_wan/model/hotword_model.dart';
import 'package:flutter_wan/common/user.dart';
import 'package:flutter_wan/model/hotword_result_model.dart';
import 'package:flutter_wan/model/article_model.dart';
import 'package:flutter_wan/model/banner_model.dart';

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

  Options _getOptions() {
    Map<String, String> map = new Map();
    List<String> cookies = User().cookie;
    map["Cookie"] = cookies.toString();
    return Options(headers: map);
  }
}