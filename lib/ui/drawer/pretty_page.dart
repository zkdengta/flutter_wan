import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_wan/http/api_service.dart';
import 'package:flutter_wan/model/pretty_model.dart';

class PrettyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new PrettyPageState();
  }

}

class PrettyPageState extends State<PrettyPage>{

  //当前页数据
  List<ResultsListBean> _datas = new List();

  //所有的照片数据
  List<PhotoViewGalleryPageOptions> photos = new List();

  int _page = 1;

  Future<Null> _getData() async {
    ApiService().getPrettyGirl((PrettyModel prettyModel){
      setState(() {
        _datas = prettyModel.results;
        for(int i =0; i < _datas.length; i++){
          PhotoViewGalleryPageOptions pageOptions = PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(_datas[i].url)
          );
          photos.add(pageOptions);
        }
      });
    }, _page);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("妹子图"),
      ),
      body: Container(
        child: PhotoViewGallery(
            pageOptions: photos,
          onPageChanged: (int index){
              if(index == photos.length-1){ //加载到最有一页
                _page++;
                _getData();
              }
          },
          backgroundDecoration: BoxDecoration(color: Colors.black87),
        ),
      ),
    );
  }
}