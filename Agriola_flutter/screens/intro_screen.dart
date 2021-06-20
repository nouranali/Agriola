import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:trial/screens/images_screen.dart';

const String title = "FileUpload Sample app";
//
const String uploadURL =
    "https://agriola-sroke462nq-uc.a.run.app/predict/plant_village";
//
const String uploadURL1 =
    "https://agriola-sroke462nq-uc.a.run.app/predict/weed_detection";
//
const String uploadURL2 =
    "https://agriola-sroke462nq-uc.a.run.app/predict/wheat_count";
const String uploadBinaryURL =
    "https://us-central1-flutteruploader.cloudfunctions.net/upload/binary";


class UploadItem {
  final String id;
  final String tag;
  final MediaType type;
  final int progress;
  final UploadTaskStatus status;

  UploadItem({
    this.id,
    this.tag,
    this.type,
    this.progress = 0,
    this.status = UploadTaskStatus.undefined,
  });

  UploadItem copyWith({UploadTaskStatus status, int progress}) => UploadItem(
      id: this.id,
      tag: this.tag,
      type: this.type,
      status: status ?? this.status,
      progress: progress ?? this.progress);

  bool isCompleted() =>
      this.status == UploadTaskStatus.canceled ||
      this.status == UploadTaskStatus.complete ||
      this.status == UploadTaskStatus.failed;
}
class UploadItem1 {
  final String id;
  final String tag;
  final MediaType type;
  final int progress;
  final UploadTaskStatus status;

  UploadItem1({
    this.id,
    this.tag,
    this.type,
    this.progress = 0,
    this.status = UploadTaskStatus.undefined,
  });

  UploadItem1 copyWith({UploadTaskStatus status, int progress}) => UploadItem1(
      id: this.id,
      tag: this.tag,
      type: this.type,
      status: status ?? this.status,
      progress: progress ?? this.progress);

  bool isCompleted() =>
      this.status == UploadTaskStatus.canceled ||
          this.status == UploadTaskStatus.complete ||
          this.status == UploadTaskStatus.failed;
}
class UploadItem2 {
  final String id;
  final String tag;
  final MediaType type;
  final int progress;
  final UploadTaskStatus status;

  UploadItem2({
    this.id,
    this.tag,
    this.type,
    this.progress = 0,
    this.status = UploadTaskStatus.undefined,
  });

  UploadItem2 copyWith({UploadTaskStatus status, int progress}) => UploadItem2(
      id: this.id,
      tag: this.tag,
      type: this.type,
      status: status ?? this.status,
      progress: progress ?? this.progress);

  bool isCompleted() =>
      this.status == UploadTaskStatus.canceled ||
          this.status == UploadTaskStatus.complete ||
          this.status == UploadTaskStatus.failed;
}
enum MediaType { Image, Video }

class UploadScreen extends StatefulWidget {
  static const routeName = '/upload-view';
  UploadScreen({Key key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {


  // first service data. >>>
  FlutterUploader uploader = FlutterUploader();
  StreamSubscription _progressSubscription;
  StreamSubscription _resultSubscription;
  Map<String, UploadItem> _tasks = {};
  String response1;

// second service data. >>
  FlutterUploader uploader1 = FlutterUploader();

  StreamSubscription _progressSubscription1;
  StreamSubscription _resultSubscription1;
  Map<String, UploadItem1> _tasks1 = {};
  String response2;
  bool isLoading1=false;
  bool isLoading2=false;
  bool isLoading3=false;

// third service data. >>
  FlutterUploader uploader2 = FlutterUploader();
  StreamSubscription _progressSubscription2;
  StreamSubscription _resultSubscription2;
  Map<String, UploadItem2> _tasks2 = {};
  String response3;
int progress1;

int progress2;
int progress3;
  @override
  void initState() {
    super.initState();
    _progressSubscription = uploader.progress.listen((progress) {

      final task = _tasks[progress.tag];
      print("progress: ${progress.progress} , tag: ${progress.tag}");
      if (task == null) return;
      if (task.isCompleted(

      )) return;
      setState(() {
        _tasks[progress.tag] =
            task.copyWith(progress: progress.progress, status: progress.status);
        progress1=progress.progress;
      });

    });
    _resultSubscription = uploader.result.listen((result) {


      print(
          "id: ${result.taskId}, status: ${result.status}, response: ${result.response}, statusCode: ${result.statusCode}, tag: ${result.tag}, headers: ${result.headers}");
      if(isLoading1) response1 = result.response.substring(14,result.response.length-1);
      isLoading1=false;
      final task = _tasks[result.tag];
      if (task == null) return;

      setState(() {
        _tasks[result.tag] = task.copyWith(status: result.status);
      });
     // uploader.dispose();
    }, onError: (ex, stacktrace) {
      print("exception: $ex");
      print("stacktrace: $stacktrace" ?? "no stacktrace");
      final exp = ex as UploadException;
      final task = _tasks[exp.tag];
      if (task == null) return;

      setState(() {
        _tasks[exp.tag] = task.copyWith(status: exp.status);
      });
    });
    // second service data.
    _progressSubscription1 = uploader1.progress.listen((progress) {

      final task = _tasks1[progress.tag];
      print("progress: ${progress.progress} , tag: ${progress.tag}");
      if (task == null) return;
      if (task.isCompleted()) return;
      setState(() {
        _tasks1[progress.tag] =
            task.copyWith(progress: progress.progress, status: progress.status);
        progress2=progress.progress;
      });
    });
    _resultSubscription1 = uploader1.result.listen((result) {

      //response2 = result.response;
      print(
          "id1: ${result.taskId}, status1: ${result.status}, response1: ${result.response}, statusCode: ${result.statusCode}, tag: ${result.tag}, headers: ${result.headers}");
      if(isLoading2) response2 = result.response.substring(14,result.response.length-1);
      isLoading2=false;
      final task = _tasks1[result.tag];
      if (task == null) return;

      setState(() {
        _tasks1[result.tag] = task.copyWith(status: result.status);

      });
     // uploader1.dispose();
    }, onError: (ex, stacktrace) {
      print("exception: $ex");
      print("stacktrace: $stacktrace" ?? "no stacktrace");
      final exp = ex as UploadException;
      final task = _tasks1[exp.tag];
      if (task == null) return;

      setState(() {
        _tasks1[exp.tag] = task.copyWith(status: exp.status);
      });
    });
// third service data.
    _progressSubscription2 = uploader2.progress.listen((progress) {

      final task = _tasks2[progress.tag];
      print("progress: ${progress.progress} , tag: ${progress.tag}");
      if (task == null) return;
      if (task.isCompleted()) return;
      setState(() {
        _tasks2[progress.tag] =
            task.copyWith(progress: progress.progress, status: progress.status);
        progress3=progress.progress;
      });
    });
    _resultSubscription2 = uploader2.result.listen((result) {

      response3 = result.response;
      print(
          "id2: ${result.taskId}, status2: ${result.status}, response2: ${result.response}, statusCode: ${result.statusCode}, tag: ${result.tag}, headers: ${result.headers}");

      final task = _tasks2[result.tag];
      if (task == null) return;

      setState(() {
        _tasks2[result.tag] = task.copyWith(status: result.status);
      });
    }, onError: (ex, stacktrace) {
      print("exception: $ex");
      print("stacktrace: $stacktrace" ?? "no stacktrace");
      final exp = ex as UploadException;
      final task = _tasks2[exp.tag];
      if (task == null) return;

      setState(() {
        _tasks2[exp.tag] = task.copyWith(status: exp.status);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _progressSubscription?.cancel();
    _resultSubscription?.cancel();
    //
    _progressSubscription1?.cancel();
    _resultSubscription1?.cancel();
    //
    _progressSubscription2?.cancel();
    _resultSubscription2?.cancel();
  }

  // gallery and camera.
  _openPickingOptions1(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (context) => Container(
        height: 155.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 20.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36.0),
                    topRight: Radius.circular(36.0)),
              ),
              child: Container(
                decoration: BoxDecoration(
                    color:  Color(0xFF4ABB6F),
                    borderRadius: BorderRadius.circular(3.0)),
                width: 35.0,
                height: 3.0,
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    splashColor: Colors.transparent,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.white,
                            border: Border.all(
                                color:  Color(0xFF4ABB6F),
                                width: 1.0),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color:  Color(0xFF4ABB6F),
                          ),
                        ),
                        SizedBox(
                          height: 7.0,
                        ),
                        Text(
                          'camera',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0),
                        ),
                      ],
                    ),
                    onTap: () async{
                      Navigator.pop(context);
                      await getImageCamera(binary: false);
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      await getImage(binary: false);
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.white,
                            border: Border.all(
                                color:  Color(0xFF4ABB6F),
                                width: 1.0),
                          ),
                          child: Icon(
                            Icons.photo_library,
                            color:  Color(0xFF4ABB6F),
                          ),
                        ),
                        SizedBox(
                          height: 7.0,
                        ),
                        Text(
                          'gallery',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(26.0),
          topLeft: Radius.circular(26.0),
        ),
      ),
    );
  }
  _openPickingOptions2(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (context) => Container(
        height: 155.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 20.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36.0),
                    topRight: Radius.circular(36.0)),
              ),
              child: Container(
                decoration: BoxDecoration(
                    color:  Color(0xFF4ABB6F),
                    borderRadius: BorderRadius.circular(3.0)),
                width: 35.0,
                height: 3.0,
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    splashColor: Colors.transparent,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.white,
                            border: Border.all(
                                color:  Color(0xFF4ABB6F),
                                width: 1.0),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color:  Color(0xFF4ABB6F),
                          ),
                        ),
                        SizedBox(
                          height: 7.0,
                        ),
                        Text(
                          'camera',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0),
                        ),
                      ],
                    ),
                    onTap: () async{
                      Navigator.pop(context);
                      await getImageCamera1(binary: false);
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      await getImage1(binary: false);
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.white,
                            border: Border.all(
                                color:  Color(0xFF4ABB6F),
                                width: 1.0),
                          ),
                          child: Icon(
                            Icons.photo_library,
                            color:  Color(0xFF4ABB6F),
                          ),
                        ),
                        SizedBox(
                          height: 7.0,
                        ),
                        Text(
                          'gallery',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(26.0),
          topLeft: Radius.circular(26.0),
        ),
      ),
    );
  }
  _openPickingOptions3(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (context) => Container(
        height: 155.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 20.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36.0),
                    topRight: Radius.circular(36.0)),
              ),
              child: Container(
                decoration: BoxDecoration(
                    color:  Color(0xFF4ABB6F),
                    borderRadius: BorderRadius.circular(3.0)),
                width: 35.0,
                height: 3.0,
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    splashColor: Colors.transparent,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.white,
                            border: Border.all(
                                color:  Color(0xFF4ABB6F),
                                width: 1.0),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color:  Color(0xFF4ABB6F),
                          ),
                        ),
                        SizedBox(
                          height: 7.0,
                        ),
                        Text(
                          'camera',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0),
                        ),
                      ],
                    ),
                    onTap: () async{
                      Navigator.pop(context);
                      await getImageCamera2(binary: false);
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      await getImage2(binary: false);
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.white,
                            border: Border.all(
                                color:  Color(0xFF4ABB6F),
                                width: 1.0),
                          ),
                          child: Icon(
                            Icons.photo_library,
                            color:  Color(0xFF4ABB6F),
                          ),
                        ),
                        SizedBox(
                          height: 7.0,
                        ),
                        Text(
                          'gallery',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(26.0),
          topLeft: Radius.circular(26.0),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4ABB6F),
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text('Agriola',
        ),
        actions: [
          Container(
              width: 50,
              child: Image.asset('assets/images/logo.png',fit: BoxFit.contain,)),
          SizedBox(width: 20,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -MediaQuery.of(context).padding.top,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(height: 50.0),
                InkWell(
                  onTap: (){
                    _openPickingOptions1(context);
                  },
                  child: Container(
                   // width: 219,
                    height: 56,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    padding:  const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                           // alignment: Alignment.center,
                            width: 55,
                            height: 45,
                            decoration: BoxDecoration(
                               // color: Color(0xFF4ABB6F),
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0x41000000),
                                      offset: Offset(0, 6),
                                      blurRadius: 9)
                                ]),
                            child: Image.asset('assets/images/first.jpg',fit: BoxFit.cover,),
                            // Icon(
                            //   Icons.photo_library,
                            //   color: Colors.white,
                            // ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Text(
                            'Check Plant Diseases',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      //  Spacer(),
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final item = _tasks.values.elementAt(index);

                      print("${item.tag} - ${item.progress} 7");
                      return
                        UploadItemView(
                          item: _tasks.values.elementAt(index),
                        onCancel: cancelUpload,
                        child: progress1==100 ?Text('response is  $response1'??''):Container(),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.black,
                      );
                    },
                  ),
                ),

                InkWell(
                  onTap: (){
                    _openPickingOptions2(context);
                  },
                  child: Container(
                    // width: 219,
                    height: 56,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    padding:  const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                       // const SizedBox(width: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            // alignment: Alignment.center,
                            width: 55,
                            height: 45,
                            decoration: BoxDecoration(
                              // color: Color(0xFF4ABB6F),
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0x41000000),
                                      offset: Offset(0, 6),
                                      blurRadius: 9)
                                ]),
                            child: Image.asset('assets/images/second.jpg',fit: BoxFit.cover,),
                            // Icon(
                            //   Icons.photo_library,
                            //   color: Colors.white,
                            // ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Text(
                            'Weed detection',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 12,
                            ),
                          ),
                        ),
                       // Spacer(),
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),

                Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _tasks1.length,
                    itemBuilder: (context, index) {
                      final item = _tasks1.values.elementAt(index);

                      print("${item.tag} - ${item.progress} 7");
                      return
                        UploadItemView1(
                          item: _tasks1.values.elementAt(index),
                          onCancel: cancelUpload2,
                          child: progress2==100 ?Text('response is  $response2'??''):Container(),
                        );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.black,
                      );
                    },
                  ),
                ),
                // second service
                Container(height: 20.0),

                InkWell(
                  onTap: (){
                    _openPickingOptions3(context);
                  },

                  child: Container(
                    // width: 219,
                    height: 56,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    padding:  const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                      //  const SizedBox(width: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            // alignment: Alignment.center,
                            width: 55,
                            height: 45,
                            decoration: BoxDecoration(
                              // color: Color(0xFF4ABB6F),
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0x41000000),
                                      offset: Offset(0, 6),
                                      blurRadius: 9)
                                ]),
                            child: Image.asset('assets/images/third.jpg',fit: BoxFit.cover,),
                            // Icon(
                            //   Icons.photo_library,
                            //   color: Colors.white,
                            // ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Text(
                            'Wheat count and detection',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        //Spacer(),
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 300,
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListView.separated(
                  //  padding: EdgeInsets.symmetric(vertical: 15),
                    itemCount: _tasks2.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = _tasks2.values.elementAt(index);

                      print("${item.tag} - ${item.progress} 7");
                      return
                        UploadItemView2(
                          item: _tasks2.values.elementAt(index),
                          onCancel: cancelUpload2,
                          child:
                          progress3==100 ?InkWell(
                            onTap: (){
                          Navigator.of(context).pushNamed(PhotoViewScreen.routeName);
                            },
                            child: Container(
                                height: 250,
                                child: Image.network('https://agriola-sroke462nq-uc.a.run.app/predict/media',
                                fit: BoxFit.cover,
                                )),
                          ):Container(),
                        );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.black,
                      );
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  String _uploadUrl({bool binary}) {
    if (binary) {
      return uploadBinaryURL;
    } else {
      return uploadURL;
    }
  }

// second service.
  String _uploadUrl1({bool binary}) {
    if (binary) {
      return uploadBinaryURL;
    } else {
      return uploadURL1;
    }
  }

  // third service
  String _uploadUrl2({bool binary}) {
    if (binary) {
      return uploadBinaryURL;
    } else {
      return uploadURL2;
    }
  }

  //
  Future getImageCamera({@required bool binary}) async {
    setState(() {
      isLoading1=true;
      _tasks.clear();
    });
    var image = await ImagePicker.pickImage(source: ImageSource.camera ,maxWidth: 600.0,);
    if (image != null) {
      final String filename = basename(image.path);
      final String savedDir = dirname(image.path);
      final tag = "image upload is "; //${_tasks.length + 1}
      var url = _uploadUrl(binary: binary);
      var fileItem = FileItem(
        filename: filename,
        savedDir: savedDir,
        fieldname: "image",
      );

      var taskId = binary
          ? await uploader.enqueueBinary(
        url: url,
        file: fileItem,
        method: UploadMethod.POST,
        tag: tag,
        showNotification: true,
      )
          : await uploader.enqueue(
        url: url,
        data: {"name": "john"},
        files: [fileItem],
        method: UploadMethod.POST,
        tag: tag,
        showNotification: true,
      );

      setState(() {
        _tasks.putIfAbsent(
            tag,
                () => UploadItem(
              id: taskId,
              tag: tag,
              type: MediaType.Video,
              status: UploadTaskStatus.enqueued,
            ));
        print('...${_tasks.values}');
      });
    }
  }
  Future getImage({@required bool binary}) async {
    setState(() {
      isLoading1=true;
      _tasks.clear();
    });
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final String filename = basename(image.path);
      final String savedDir = dirname(image.path);
      final tag = "image upload is "; //${_tasks.length + 1}
      var url = _uploadUrl(binary: binary);
      var fileItem = FileItem(
        filename: filename,
        savedDir: savedDir,
        fieldname: "image",
      );

      var taskId = binary
          ? await uploader.enqueueBinary(
              url: url,
              file: fileItem,
              method: UploadMethod.POST,
              tag: tag,
              showNotification: true,
            )
          : await uploader.enqueue(
              url: url,
              data: {"name": "john"},
              files: [fileItem],
              method: UploadMethod.POST,
              tag: tag,
              showNotification: true,
            );

      setState(() {
        _tasks.putIfAbsent(
            tag,
            () => UploadItem(
                  id: taskId,
                  tag: tag,
                  type: MediaType.Video,
                  status: UploadTaskStatus.enqueued,
                ));
        print('...${_tasks.values}');
      });
    }
  }

  Future cancelUpload(String id) async {
    await uploader.cancel(taskId: id);
  }

  // second service
  Future getImageCamera1({@required bool binary}) async {
    setState(() {
      isLoading2=true;
      _tasks1.clear();
    });
    var image = await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 600.0,);
    if (image != null) {
      final String filename = basename(image.path);
      final String savedDir = dirname(image.path);
      final tag = "image Upload is "; //${_tasks1.length + 1}
      var url = _uploadUrl1(binary: binary);
      var fileItem = FileItem(
        filename: filename,
        savedDir: savedDir,
        fieldname: "image",
      );

      var taskId = binary
          ? await uploader1.enqueueBinary(
        url: url,
        file: fileItem,
        method: UploadMethod.POST,
        tag: tag,
        showNotification: true,
      )
          : await uploader1.enqueue(
        url: url,
        data: {"name": "ahmed"},
        files: [fileItem],
        method: UploadMethod.POST,
        tag: tag,
        showNotification: true,
      );

      setState(() {
        _tasks1.putIfAbsent(
            tag,
                () => UploadItem1(
              id: taskId,
              tag: tag,
              type: MediaType.Video,
              status: UploadTaskStatus.enqueued,
            ));
        print('...1${_tasks1.values}');
      });
    }
  }
  Future getImage1({@required bool binary}) async {
    setState(() {
      isLoading2=true;
      _tasks1.clear();
    });
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final String filename = basename(image.path);
      final String savedDir = dirname(image.path);
      final tag = "image Upload is "; //${_tasks1.length + 1}
      var url = _uploadUrl1(binary: binary);
      var fileItem = FileItem(
        filename: filename,
        savedDir: savedDir,
        fieldname: "image",
      );

      var taskId = binary
          ? await uploader1.enqueueBinary(
              url: url,
              file: fileItem,
              method: UploadMethod.POST,
              tag: tag,
              showNotification: true,
            )
          : await uploader1.enqueue(
              url: url,
              data: {"name": "ahmed"},
              files: [fileItem],
              method: UploadMethod.POST,
              tag: tag,
              showNotification: true,
            );

      setState(() {
        _tasks1.putIfAbsent(
            tag,
            () => UploadItem1(
                  id: taskId,
                  tag: tag,
                  type: MediaType.Video,
                  status: UploadTaskStatus.enqueued,
                ));
        print('...1${_tasks1.values}');
      });
    }
  }

  Future cancelUpload1(String id) async {
    await uploader1.cancel(taskId: id);
  }

  // third service
  Future getImageCamera2({@required bool binary}) async {
    setState(() {
      _tasks2.clear();
    });
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 600.0,);
    if (image != null) {
      final String filename = basename(image.path);
      final String savedDir = dirname(image.path);
      final tag = "image upload is "; //${_tasks2.length + 1}
      var url = _uploadUrl2(binary: binary);
      var fileItem = FileItem(
        filename: filename,
        savedDir: savedDir,
        fieldname: "image",
      );

      var taskId = binary
          ? await uploader2.enqueueBinary(
        url: url,
        file: fileItem,
        method: UploadMethod.POST,
        tag: tag,
        showNotification: true,
      )
          : await uploader2.enqueue(
        url: url,
        data: {"name": "john"},
        files: [fileItem],
        method: UploadMethod.POST,
        tag: tag,
        showNotification: true,
      );

      setState(() {
        _tasks2.putIfAbsent(
            tag,
                () => UploadItem2(
              id: taskId,
              tag: tag,
              type: MediaType.Video,
              status: UploadTaskStatus.enqueued,
            ));

      });
    }
  }
  Future getImage2({@required bool binary}) async {
    setState(() {
      _tasks2.clear();
    });
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final String filename = basename(image.path);
      final String savedDir = dirname(image.path);
      final tag = "image upload is "; //${_tasks2.length + 1}
      var url = _uploadUrl2(binary: binary);
      var fileItem = FileItem(
        filename: filename,
        savedDir: savedDir,
        fieldname: "image",
      );

      var taskId = binary
          ? await uploader2.enqueueBinary(
              url: url,
              file: fileItem,
              method: UploadMethod.POST,
              tag: tag,
              showNotification: true,
            )
          : await uploader2.enqueue(
              url: url,
              data: {"name": "john"},
              files: [fileItem],
              method: UploadMethod.POST,
              tag: tag,
              showNotification: true,
            );

      setState(() {
        _tasks2.putIfAbsent(
            tag,
            () => UploadItem2(
                  id: taskId,
                  tag: tag,
                  type: MediaType.Video,
                  status: UploadTaskStatus.enqueued,
                ));

      });
    }
  }

  Future cancelUpload2(String id) async {
    await uploader2.cancel(taskId: id);
  }
}

typedef CancelUploadCallback = Future<void> Function(String id);
typedef CancelUploadCallback1 = Future<void> Function(String id);
typedef CancelUploadCallback2 = Future<void> Function(String id);
class UploadItemView extends StatelessWidget {
  final UploadItem item;
  final CancelUploadCallback onCancel;
  final Widget child;

  UploadItemView({
    Key key,
    this.item,
    this.child,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = item.progress.toDouble() / 100;
    final widget = item.status == UploadTaskStatus.running
        ? LinearProgressIndicator(value: progress)
        : Container();
    final buttonWidget = item.status == UploadTaskStatus.running
        ? Container(
            height: 50,
            width: 50,
            child: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () => onCancel(item.id),
            ),
          )
        : Container();
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.tag),
                  // Container(
                  //   height: 5.0,
                  // ),
                  Text(item.status.description),
                ],
              ),
              Container(
                height: 5.0,
              ),
              widget,
              if(item.status == UploadTaskStatus.complete) child,
            ],
          ),
        ),
       // buttonWidget,

      ],
    );
  }
}
class UploadItemView1 extends StatelessWidget {
  final UploadItem1 item;
  final CancelUploadCallback1 onCancel;
  final Widget child;

  UploadItemView1({
    Key key,
    this.item,
    this.child,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = item.progress.toDouble() / 100;
    final widget = item.status == UploadTaskStatus.running
        ? LinearProgressIndicator(value: progress)
        : Container();
    final buttonWidget = item.status == UploadTaskStatus.running
        ? Container(
      height: 50,
      width: 50,
      child: IconButton(
        icon: Icon(Icons.cancel),
        onPressed: () => onCancel(item.id),
      ),
    )
        : Container();
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.tag),
                  // Container(
                  //   height: 5.0,
                  // ),
                  Text(item.status.description),
                ],
              ),
              Container(
                height: 5.0,
              ),
              widget,
              if(item.status == UploadTaskStatus.complete) child,
            ],
          ),
        ),
       // buttonWidget,

      ],
    );
  }
}
class UploadItemView2 extends StatelessWidget {
  final UploadItem2 item;
  final CancelUploadCallback2 onCancel;
  final Widget child;

  UploadItemView2({
    Key key,
    this.item,
    this.child,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = item.progress.toDouble() / 100;
    final widget = item.status == UploadTaskStatus.running
        ? LinearProgressIndicator(value: progress)
        : Container();
    final buttonWidget = item.status == UploadTaskStatus.running
        ? Container(
      height: 50,
      width: 50,
      child: IconButton(
        icon: Icon(Icons.cancel),
        onPressed: () => onCancel(item.id),
      ),
    )
        : Container();
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.tag),
                  // Container(
                  //   height: 5.0,
                  // ),
                  Text(item.status.description),
                ],
              ),
              Container(
                height: 5.0,
              ),
              widget,
             if(item.status == UploadTaskStatus.complete) child,

            ],
          ),
        ),
       // buttonWidget,

      ],
    );
  }
}