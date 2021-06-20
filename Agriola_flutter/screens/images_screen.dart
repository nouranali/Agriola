import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PhotoViewScreen extends StatefulWidget {
  static const routeName = '/photo-view';
  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: AppBar(elevation: 0,
        backgroundColor: Color(0xFF4ABB6F),
        title: Text('View Photo'),
      ),
      body: ListView.separated(
        itemCount: 1,
        padding: EdgeInsets.only(top: 25),
        itemBuilder: (ctx,i)=>ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
           // height: MediaQuery.of(context).size.height*.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Image.network('https://agriola-sroke462nq-uc.a.run.app/predict/media',fit: BoxFit.cover,),
          ),
        ),
        shrinkWrap: true,
        //physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (ctx,idx)=>Divider(height: 15,color: Colors.white,),
      )
    );
  }
}
