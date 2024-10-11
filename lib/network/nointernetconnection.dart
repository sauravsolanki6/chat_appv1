import 'package:flutter/material.dart';

import '../customisedesign.dart/buttondesign.dart';
import 'checkinternetconnection.dart';

class NoInternetConnection extends StatefulWidget {
  State createState() => NoInternetConnectionState();
}

class NoInternetConnectionState extends State<NoInternetConnection> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('No Internet Connection'),
        ),
        body: Container(
          alignment: Alignment.center,
          margin: new EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Spacer(),
              Center(
                  child: Image.asset(
                'assets/images/wifi.png',
                width: 200.0,
                height: 300.0,
              )),
              Text(
                'OPPS!!',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'NO INTERNET',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text('Please check internet connection'),
              Container(
                  alignment: Alignment.bottomCenter,
                  margin: new EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(3.0),
                  child: ButtonDesign(
                    onPressed: () {
                      checkInternet();
                    },
                    child: Text(
                      'REFRESH',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ],
          ),
        ));
  }

  checkInternet() async {
    Future<bool> _connection = CheckInternetConnection().hasNetwork();
    if (await _connection) {
      Navigator.pop(context);
    }
  }
}
