import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';


/// The Rotation measures the acceleration applied to the sensor
/// built-in into the device, including the force of gravity.
///
/// Your can initialize this class by the following code.
/// ```dart
/// var sensor = RotationSensor();
/// ```
///
/// If you need to initialize the sensor with configurations,
/// you can use the following code instead of the above code.
/// ```dart
/// var config =  RotationSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
///
/// var sensor = RotationSensor.init(config);
/// ```
///
/// Each sub class of AwareSensor provides the following method for controlling
/// the sensor:
/// - `start()`
/// - `stop()`
/// - `enable()`
/// - `disable()`
/// - `sync()`
/// - `setLabel(String label)`
///
/// `Stream<RotationData>` allow us to monitor the sensor update
/// events as follows:
///
/// ```dart
/// sensor.onDataChanged.listen((data) {
///   print(data)
/// }
/// ```
///
/// In addition, this package support data visualization function on Cart Widget.
/// You can generate the Cart Widget by following code.
/// ```dart
/// var card = RotationCard(sensor: sensor);
/// ```
class RotationSensor extends AwareSensor {
  static const MethodChannel _rotationMethod = const MethodChannel('awareframework_rotation/method');
  // static const EventChannel  _rotationStream  = const EventChannel('awareframework_rotation/event');

  static const EventChannel  _onDataChangedStream  = const EventChannel('awareframework_rotation/event_on_data_changed');

  StreamController<RotationData> onDataChangedStreamController = StreamController<RotationData>();

  /// Init Rotation Sensor without a configuration file
  ///
  /// ```dart
  /// var sensor = RotationSensor.init(null);
  /// ```
  RotationSensor():this.init(null);

  /// Init Rotation Sensor with RotationSensorConfig
  ///
  /// ```dart
  /// var config =  RotationSensorConfig();
  /// config
  ///   ..debug = true
  ///   ..frequency = 100;
  ///
  /// var sensor = RotationSensor.init(config);
  /// ```
  RotationSensor.init(RotationSensorConfig config) : super(config){
    super.setMethodChannel(_rotationMethod);
  }

  /// A sensor observer instance
  Stream<RotationData> get onDataChanged {
    onDataChangedStreamController.close();
    onDataChangedStreamController = StreamController<RotationData>();
    return onDataChangedStreamController.stream;
  }


  @override
  Future<Null> start() {
    super.getBroadcastStream(_onDataChangedStream , "on_data_changed").map(
            (dynamic event) => RotationData.from(Map<String,dynamic>.from(event))
    ).listen((event){
      if(!onDataChangedStreamController.isClosed){
        onDataChangedStreamController.add(event);
      }
    });
    return super.start();
  }

  @override
  Future<Null> stop() {
    super.cancelBroadcastStream("on_data_changed");
    return super.stop();
  }
}


/// A configuration class of RotationSensor
///
/// You can initialize the class by following code.
///
/// ```dart
/// var config =  RotationSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
/// ```
class RotationSensorConfig extends AwareSensorConfig{

  RotationSensorConfig();

  int frequency    = 5;
  double period    = 1.0;
  double threshold = 0.0;

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['frequency'] = frequency;
    map['period']    = period;
    map['threshold'] = threshold;
    return map;
  }
}

/// A data model of RotationSensor
///
/// This class converts sensor data that is Map<String,dynamic> format, to a
/// sensor data object.
///
class RotationData extends AwareData {
  Map<String,dynamic> source;
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  int eventTimestamp = 0;
  int accuracy = 0;
  RotationData():this.from(null);
  RotationData.from(Map<String,dynamic> data):super.from(data){
    if (data != null) {
      x = data["x"];
      y = data["y"];
      z = data["z"];
      eventTimestamp = data["eventTimestamp"];
      accuracy = data["accuracy"];
      source = data;
    }
  }

  @override
  String toString() {
    if(source != null){
      return source.toString();
    }
    return super.toString();
  }
}

///
/// A Card Widget of Rotation Sensor
///
/// You can generate a Cart Widget by following code.
/// ```dart
/// var card = RotationCard(sensor: sensor);
/// ```
class RotationCard extends StatefulWidget {
  RotationCard({Key key, @required this.sensor, this.bufferSize = 299, this.height = 250.0 }) : super(key: key);

  final RotationSensor sensor;
  final int bufferSize;
  final double height;

  @override
  RotationCardState createState() => new RotationCardState();

  final List<LineSeriesData> dataLine1 = List<LineSeriesData>();
  final List<LineSeriesData> dataLine2 = List<LineSeriesData>();
  final List<LineSeriesData> dataLine3 = List<LineSeriesData>();

}

///
/// A Card State of Rotation Sensor
///
class RotationCardState extends State<RotationCard> {

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onDataChanged.listen((event) {
      if(mounted){
        setState((){
          if(event!=null){
            DateTime.fromMicrosecondsSinceEpoch(event.timestamp);
            StreamLineSeriesChart.add(data:event.x, into:widget.dataLine1, id:"x", buffer: widget.bufferSize);
            StreamLineSeriesChart.add(data:event.y, into:widget.dataLine2, id:"y", buffer: widget.bufferSize);
            StreamLineSeriesChart.add(data:event.z, into:widget.dataLine3, id:"z", buffer: widget.bufferSize);
          }
        });
      }
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });
    print(widget.sensor);
  }

  @override
  Widget build(BuildContext context) {
    var data = StreamLineSeriesChart.createTimeSeriesData(widget.dataLine1, widget.dataLine2, widget.dataLine3);
    return new AwareCard(
      contentWidget: SizedBox(
          height:widget.height,
          width: MediaQuery.of(context).size.width*0.8,
          child: new StreamLineSeriesChart(data),
        ),
      title: "Rotation",
      sensor: widget.sensor
    );
  }
}
