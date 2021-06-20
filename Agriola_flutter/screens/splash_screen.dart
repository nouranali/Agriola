
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trial/screens/intro_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacityVal = 0.0;

  Future<void> hideScreen() async {

    Future.delayed(Duration(milliseconds: 4000), () {
      if (this.mounted)
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            opaque: true,
            settings: RouteSettings(name: UploadScreen.routeName ),
            transitionDuration: const Duration(milliseconds: 1500),
            pageBuilder: (BuildContext context, _, __) =>  UploadScreen(),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) =>
                    FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        );
    });
  }

  // map search data.
  String mapId;
  String longitude;
  String latitude;
  bool isMapRegions;
  @override
  void didChangeDependencies() {
    hideScreen();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body:
        Container(
          alignment: Alignment.center,
          child:Image(image: new AssetImage("assets/images/logo.png"))
          //Image.asset('assets/images/logo.png'),
        )
    );
  }
}
