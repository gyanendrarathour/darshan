import 'package:darshan/view/adminView.dart';
import 'package:darshan/view/homeView.dart';
import 'package:flutter/material.dart';

class Splashview extends StatefulWidget {
  const Splashview({super.key});

  @override
  State<Splashview> createState() => _SplashviewState();
}

class _SplashviewState extends State<Splashview> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Homeview()));
});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          const SizedBox(
              height: double.infinity,
              child: Image(
                image: AssetImage('images/splash.jpg'),
                fit: BoxFit.fill,
              )),
          Container(
              width: double.infinity,
              height: 90,
              decoration: const BoxDecoration(color: Colors.black54),
              child: const Center(
                  child: Column(
                    children: [
                      Text('D  A  R  S  H  A  N     A  P  P',
                          style:
                              TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold)),
                      Divider(),
                      Text('DEVELOPED BY:   GYANENDRA SINGH',
                          style:
                              TextStyle(fontSize: 18, color: Colors.white)),
                    ],
                  )))
        ],
      ),
    );
  }
}
