import 'package:flutter/material.dart';

class view extends StatefulWidget {
  dynamic id;

  String displayName="";
  view(this.id,this.displayName);

  

  @override
  State<view> createState() => _viewState();
}

class _viewState extends State<view> {
  List l=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("view music"),),
      
      body:
      Card(margin: EdgeInsets.all(15),child: ListTile(
        // trailing: Image.network("${widget.id}"),

        title: Text("${widget.displayName}"),),)
    );
  }
}
