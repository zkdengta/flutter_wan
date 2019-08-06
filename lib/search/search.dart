import 'package:flutter/material.dart';
import 'package:flutter_wan/model/hotword_model.dart';
import 'package:flutter_wan/util/utils.dart';
import 'package:flutter_wan/http/api_service.dart';

class SearchPage extends StatefulWidget{
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController editingController;
  FocusNode focusNode = new FocusNode();
  List<Widget> actions = new List();
  List<DataListBean> _datas = new List();
  String search;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    editingController = new TextEditingController(text: search);
    editingController.addListener((){
      if(editingController.text == null || editingController.text == ""){
        setState(() {
          actions = [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                changeContent();
              },
            )
          ];
        });
      }else{
        setState(() {
          actions = [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: (){
                editingController.clear();
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                changeContent();
              },
            ),
          ];
        });
      }
    });
    _getData();
  }

  void changeContent(){
    focusNode.unfocus();
    setState(() {
      if (editingController.text == null || editingController.text == "") {

      }else{
//        Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
//          return new HotResultPage(editingController.text);
//        }));
      }
    });
  }

  ///获取文章列表数据
  Future<Null> _getData() async {
    ApiService().getSearchHotWord((HotwordModel hotwordMadel){
      setState(() {
        _datas = hotwordMadel.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    TextField searchField = new TextField(
      autofocus: true,
      style: TextStyle(color: Colors.white),
      decoration: new InputDecoration(
        hintStyle: TextStyle(color: Colors.white),
        border: InputBorder.none,
        hintText: "搜索更多干货"
      ),
      focusNode: focusNode,
      controller: editingController,
    );
    
    return Scaffold(
      appBar: AppBar(
        title: searchField,
        actions: actions,
      ),
      body: buildChildren(_datas),
    );
  }

  Widget buildChildren(List<DataListBean> datas) {
    List<Widget> names = [];//先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget

    for(DataListBean item in datas){
      names.add(new InkWell(
        child: new Chip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: Utils.getChipBgColor(item.name),
            label: new Text(item.name),
        ),
        onTap: (){
//          Navigator.of(context).push(new MaterialPageRoute(builder: (context){
//            return new HosResultPage();
//          }));
        },
      ));
    }
    content = Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Wrap(
        spacing: 12.0,
        runSpacing: 12.0,
        alignment: WrapAlignment.start,
        children: names,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            "热门搜索",
            style: TextStyle(color: const Color(0xFF5394FF),fontSize: 18.0),
          ),
        ),
        content,
      ],
    );
  }
}
