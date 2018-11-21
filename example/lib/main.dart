import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_rotation/awareframework_rotation.dart';
import 'package:awareframework_core/awareframework_core.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  RotationSensor sensor;
  RotationSensorConfig config;

  @override
  void initState() {
    super.initState();

    config = RotationSensorConfig()
      ..debug = true;

    sensor = new RotationSensor(config);

  }

  @override
  Widget build(BuildContext context) {


    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin Example App'),
          ),
          body: new RotationCard(sensor: sensor,)
      ),
    );
  }
}
