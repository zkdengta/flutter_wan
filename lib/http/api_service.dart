import 'package:dio/dio.dart';
import 'package:flutter_wan/http/dio_manager.dart';
import 'package:flutter_wan/http/api.dart';
import 'package:flutter_wan/model/hotword_model.dart';
import 'package:flutter_wan/common/user.dart';


class ApiService{

  ///获取搜索热词
  void getSearchHotWord(Function callback) async {
    DioManager.singleton.dio
        .get(Api.SEARCH_HOT_WORD,options:_getOptions())
        .then((response){
          callback(HotwordModel.fromMap(response.data));
    });
  }

  Options _getOptions() {
    Map<String, String> map = new Map();
    List<String> cookies = User().cookie;
    map["Cookie"] = cookies.toString();
    return Options(headers: map);
  }
}