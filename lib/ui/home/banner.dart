import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_wan/http/api_service.dart';
import 'package:flutter_wan/model/banner_model.dart';
import 'package:flutter_wan/ui/common/webview_page.dart';

class BannerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BannerWidgetState();
  }

}

class BannerWidgetState extends State<BannerWidget>{
  List<BannerData> _bannerList = new List();

  @override
  void initState() {
    _bannerList.add(null);
    _getBanner();
  }

  Future<Null> _getBanner() {
    ApiService().getBanner((BannerModel _bannerModel) {
      if (_bannerModel.data.length > 0) {
        setState(() {
          _bannerList = _bannerModel.data;
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Swiper(
      itemBuilder: (BuildContext context,int index){
        if(_bannerList[index] == null||_bannerList[index].imagePath == null){
          return new Container(
            color: Colors.grey[100],
          );
        }else{
          return buildItemImageWidget(context,index);
        }
      },
      itemCount: _bannerList.length,
      autoplay: true,
      pagination: new SwiperPagination(),
    );
  }

  Widget buildItemImageWidget(BuildContext context, int index) {
    return new InkWell(
      onTap: (){
        Navigator.of(context).push(new MaterialPageRoute(builder: (context){
          return new WebViewPage(title: _bannerList[index].title,url: _bannerList[index].url);
        }));
      },
      child: new Container(
        child: new Image.network(
          _bannerList[index].imagePath,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}