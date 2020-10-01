import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _data = '';
  bool _scanning = false;
  FlutterScanBluetooth _bluetooth = FlutterScanBluetooth();

  @override
  void initState() {
    super.initState();

    _bluetooth.devices.listen((device) {
      setState(() {
        _data += device.name + ' (${device.address})\n' + DateTime.now().toString() + '\n\n';
        print(_data);
        print(DateTime.now());
      });
    });

    _bluetooth.startScan(pairedDevices: false);

    setState(() {
      _scanning = true;
    });
    /* _bluetooth.scanStopped.listen((device) {
      setState(() {
        _scanning = false;
        //  _data += 'scan stopped\n';
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Bluetooth detection log'),
        ),
        body: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(_data ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: RaisedButton(
                        child: Text('scan now'),
                        onPressed: () async {
                          try {
                            if (_scanning) {
                              await _bluetooth.startScan(pairedDevices: false);
                              debugPrint("scanning restarted");
                              setState(() {
                                // _data = '';
                                _scanning = true;
                              });
                            }
                            /*else {
                            await _bluetooth.startScan(pairedDevices: false);
                            debugPrint("scanning started");
                          }*/
                          } on PlatformException catch (e) {
                            debugPrint(e.toString());
                          }
                        }),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Text(
      ' Date ${now.day}:${now.month}:${now.year}'
          '\t'
          'time ${now.hour}:${now.minute}:${now.second}',
      style: TextStyle(color: Colors.red),
    );
  }
}