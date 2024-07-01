import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:darshan/view/homeView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Splashview extends StatefulWidget {
  const Splashview({super.key});

  @override
  State<Splashview> createState() => _SplashviewState();
}

class _SplashviewState extends State<Splashview> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // developer.log('Couldn\'t check connectivity status', error: e);
      return print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
      if (_connectionStatus.contains(ConnectivityResult.none)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('No Enternet')));
      } else {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Homeview()));
        });
      }
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
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
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Divider(),
                  Text('DEVELOPED BY:   GYANENDRA SINGH',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ],
              )))
        ],
      ),
    );
  }
}
