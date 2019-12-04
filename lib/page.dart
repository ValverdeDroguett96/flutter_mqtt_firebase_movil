import 'package:flutter/material.dart';
import 'dart:async';
import 'package:logincloud/thermometer_widget.dart';

import 'package:mqtt_client/mqtt_client.dart' as mqtt;

import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter_sparkline/flutter_sparkline.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:unicorndial/unicorndial.dart';

import 'package:fluttertoast/fluttertoast.dart';


class Pintar extends StatefulWidget {
  @override
  _PintarState createState() => _PintarState();

}


class _PintarState extends State<Pintar> {


  String broker = 'soldier.cloudmqtt.com';
  int port = 18361;
  String username = 'placa1';
  String passwd = '12345678';
  String clientIdentifier = 'MIGUE';
  String clientIdentifier1 = 'MIGUE';
  String clientIdentifier2= 'MIGUE';

  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;

  mqtt.MqttClient client1;
  mqtt.MqttConnectionState connectionState1;

  mqtt.MqttClient client2;
  mqtt.MqttConnectionState connectionState2;

  double _temp = 0 ;
  double _huma = 0 ;
  double _hums = 0 ;
  StreamSubscription subscription;
  StreamSubscription subscription1;
  StreamSubscription subscription2;


  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] Subscribing to ${topic.trim()}');
      client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
    }
  }

  void _subscribeToTopic1(String topic1) {
    if (connectionState1 == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] Subscribing to ${topic1.trim()}');
      client1.subscribe(topic1, mqtt.MqttQos.exactlyOnce);
    }
  }
  void _subscribeToTopic2(String topic2) {
    if (connectionState2 == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] Subscribing to ${topic2.trim()}');
      client2.subscribe(topic2, mqtt.MqttQos.exactlyOnce);
    }
  }

  static final List<String> chartDropdownItems = [
    'Last 7 days',
    'Last month',
    'Last year'
  ];
  String actualDropdown = chartDropdownItems[0];

  List<double> _temperatura(){
    List<double> result = <double>[_temp];

    return result;
  }


  @override
  Widget build(BuildContext context) {

    var childButtons = List<UnicornButton>();


    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Temperatura",
        currentButton: FloatingActionButton(
          heroTag: "T°",
          backgroundColor: Colors.lightGreen,
          mini: true,
          child: Icon(Icons.show_chart),
          onPressed: _connect,
        )));

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Humedad Ambiente",
        currentButton: FloatingActionButton(
          heroTag: "HA%",
          backgroundColor: Colors.lightGreen,
          mini: true,
          child: Icon(Icons.pie_chart),
          onPressed: _connect1,
        )));

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Humedad Suelo",
        currentButton: FloatingActionButton(
          heroTag: "HS%",
          backgroundColor: Colors.lightGreen,
          mini: true,
          child: Icon(Icons.insert_chart),
          onPressed: _connect2,
        )));

    var data5 = _temperatura();

    var data2 = [0.0, 1.0, 10.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];

    return Scaffold
      (
        appBar: AppBar
          (
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: Text('Monitoreo', style: TextStyle(color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 30.0)),
          actions: <Widget>
          [
            Container
              (
              margin: EdgeInsets.only(right: 8.0),
              child: Row
                (
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>
                [
                  Text('Agrino', style: TextStyle(color: Colors.black54,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0)),
                  Icon(Icons.graphic_eq, color: Colors.black54)
                ],
              ),
            )
          ],
        ),
        body: StaggeredGridView.count(

          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 35.0,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          children: <Widget>[
            _buildTile(
              Padding
                (
                padding: const EdgeInsets.all(24.0),
                child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Column
                        (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Text('Temperatura',
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('$_temp', style: TextStyle(color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 34.0))
                        ],
                      ),
                      Material
                        (
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(48.0),
                          child: Center
                            (
                              child: Padding
                                (
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.timeline, color: Colors.white,
                                    size: 30.0),
                              )
                          )
                      )
                    ]
                ),
              ),
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column
                  (
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Material
                        (
                          color: Colors.teal,
                          shape: CircleBorder(),
                          child: Padding
                            (
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.table_chart,
                                color: Colors.white, size: 30.0),
                          )
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 16.0)),
                      Text('Humedad Ambiente', style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0)),
                      Text('$_huma',
                          style: TextStyle(color: Colors.black45)),
                    ]
                ),
              ),
            ),
            _buildTile(
              Padding
                (
                padding: const EdgeInsets.all(24.0),
                child: Column
                  (
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Material
                        (
                          color: Colors.amber,
                          shape: CircleBorder(),
                          child: Padding
                            (
                            padding: EdgeInsets.all(16.0),
                            child: Icon(
                                Icons.multiline_chart, color: Colors.white,
                                size: 30.0),
                          )
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 16.0)),
                      Text('Humedad Suelo', style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0)),
                      Text('$_hums', style: TextStyle(color: Colors.black45)),
                    ]
                ),
              ),
            ),
            _buildTile(
              Padding
                (
                  padding: const EdgeInsets.all(24.0),
                  child: Column
                    (
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Row
                        (
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Column
                            (
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>
                            [

                            ],
                          ),
                          DropdownButton
                            (
                              isDense: true,
                              value: actualDropdown,
                              onChanged: (String value) =>
                                  setState(() {
                                    actualDropdown = value;
                                  }),
                              items: chartDropdownItems.map((String title) {
                                return DropdownMenuItem
                                  (
                                  value: title,
                                  child: Text(title, style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0)),
                                );
                              }).toList()
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 4.0)),

                      SfRadialGauge(
                          title:GaugeTitle(text: 'Temperatura', textStyle: const TextStyle(
                              fontSize: 20.0,fontWeight: FontWeight.bold)),
                          axes: <RadialAxis>[
                            RadialAxis(minimum: 0,maximum: 60,
                                ranges: [
                                  GaugeRange(startValue: 0,endValue: 20,color: Colors.green,startWidth: 10,endWidth: 10),
                                  GaugeRange(startValue: 20,endValue: 40,color: Colors.orange,startWidth: 10,endWidth: 10),
                                  GaugeRange(startValue: 40,endValue: 60,color: Colors.red,startWidth: 10,endWidth: 10)],
                                pointers: <GaugePointer>[NeedlePointer(value:_temp)],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(widget: Container(child:
                                  Text('$_temp',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                                      angle: 90,positionFactor: 0.5)])]
                      ),

                      SfRadialGauge(
                          title:GaugeTitle(text: 'Humedad Ambiente', textStyle: const TextStyle(
                              fontSize: 20.0,fontWeight: FontWeight.bold)),
                          axes: <RadialAxis>[
                            RadialAxis(minimum: 0,maximum: 120,
                                ranges: [
                                  GaugeRange(startValue: 0,endValue: 40,color: Colors.blue,startWidth: 10,endWidth: 10),
                                  GaugeRange(startValue: 40,endValue: 80,color: Colors.blue,startWidth: 10,endWidth: 10),
                                  GaugeRange(startValue: 80,endValue: 120,color: Colors.blue,startWidth: 10,endWidth: 10)],
                                pointers: <GaugePointer>[NeedlePointer(value:_huma)],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(widget: Container(child:
                                  Text('$_huma',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                                      angle: 90,positionFactor: 0.5)])]
                      ),

                      SfRadialGauge(
                          title:GaugeTitle(text: 'Humedad Suelo', textStyle: const TextStyle(
                              fontSize: 20.0,fontWeight: FontWeight.bold)),
                          axes: <RadialAxis>[
                            RadialAxis(minimum: 0,maximum: 120,
                                ranges: [
                                  GaugeRange(startValue: 0,endValue: 40,color: Colors.brown,startWidth: 10,endWidth: 10),
                                  GaugeRange(startValue: 40,endValue: 80,color: Colors.brown,startWidth: 10,endWidth: 10),
                                  GaugeRange(startValue: 80,endValue: 120,color: Colors.brown,startWidth: 10,endWidth: 10)],
                                pointers: <GaugePointer>[NeedlePointer(value:_hums)],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(widget: Container(child:
                                  Text('$_hums',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                                      angle: 90,positionFactor: 0.5)])]
                      ),

                    ],
                  )
              ),
            ),

          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(1, 180.0),
            StaggeredTile.extent(1, 180.0),
            StaggeredTile.extent(2, 950),
            StaggeredTile.extent(2, 110.0)
          ],
        ),

          floatingActionButton: UnicornDialer(
              backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
              parentButtonBackground: Colors.lightGreen,
              orientation: UnicornOrientation.VERTICAL,
              parentButton: Icon(Icons.add),
              childButtons: childButtons),

    );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () {
              print('Not set yet');
            },
            child: child
        )
    );
  }


  /*@override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
        appBar: AppBar
          (
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: Text('Dashboard', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 30.0)),
          actions: <Widget>
          [
            Container
              (
              margin: EdgeInsets.only(right: 8.0),
              child: Row
                (
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>
                [
                  Text('beclothed.com', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700, fontSize: 14.0)),
                  Icon(Icons.arrow_drop_down, color: Colors.black54)
                ],
              ),
            )
          ],
        ),
        body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: <Widget>[
            _buildTile(
              Padding
                (
                  padding: const EdgeInsets.all(24.0),
                  child: Column
                    (
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Row
                        (
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Column
                            (
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>
                            [
                              Text('Revenue', style: TextStyle(color: Colors.green)),
                              Text('\$16K', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0)),
                            ],
                          ),

                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 4.0)),
                      new Sparkline
                        (
                        data: [data1],
                        lineWidth: 5.0,
                        lineColor: Colors.greenAccent,
                      )

                    ],

                  )

              ),

            ),

          ],

        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _connect,
        tooltip: 'Play',
        child: Icon(Icons.play_arrow),
      )
    );

  }*/



  /*Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () { print('Not set yet'); },
            child: child
        )
    );
  }*/




 /* @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperatura'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: Card(
                elevation: 20,
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Sensor de Temperatura:',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text('$_temp C'),
                      leading: Icon(
                        Icons.toys,
                        color: Colors.blue[500],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _connect,
        tooltip: 'Play',
        child: Icon(Icons.play_arrow),
      ),
    );
  }*/


 /* @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: Text('Temperatura'),
      ),
      body: Center(

        child: SizedBox(
          child: ThermometerWidget(
            borderColor: Colors.red,
            innerColor: Colors.green,
            indicatorColor: Colors.red,
            temperature: _temp,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _connect,
        tooltip: 'Play',
        child: Icon(Icons.play_arrow),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }*/

  void _connect() async {
    /// First create a client, the client is constructed with a broker name, client identifier
    /// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
    /// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
    /// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
    /// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
    /// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
    /// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
    /// of 1883 is used.
    /// If you want to use websockets rather than TCP see below.
    ///
    client = mqtt.MqttClient(broker, '');
    client.port = port;

    /// A websocket URL must start with ws:// or wss:// or Dart will throw an exception, consult your websocket MQTT broker
    /// for details.
    /// To use websockets add the following lines -:
    /// client.useWebSocket = true;
    /// client.port = 80;  ( or whatever your WS port is)
    /// Note do not set the secure flag if you are using wss, the secure flags is for TCP sockets only.

    /// Set logging on if needed, defaults to off
    client.logging(on: true);

    /// If you intend to use a keep alive value in your connect message that is not the default(60s)
    /// you must set it here
    client.keepAlivePeriod = 30;

    /// Add the unsolicited disconnection callback
    client.onDisconnected = _onDisconnected;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password, the default keepalive interval(60s)
    /// and clean session, an example of a specific one below.
    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
        .withWillQos(mqtt.MqttQos.atMostOnce);
    print('[MQTT client] MQTT client connecting....');
    client.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.

    try {
      await client.connect(username, passwd);
    } catch (e) {
      print(e);
      _disconnect();
    }

    /// Check if we are connected
    if (client.connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] connected');
      setState(() {
        connectionState = client.connectionState;
      });
    } else {
      print('[MQTT client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client.connectionState}');
      _disconnect();
    }

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    subscription = client.updates.listen(_onMessage);

    _subscribeToTopic("placa1/temperatura");

  }

  void _connect1() async {
    /// First create a client, the client is constructed with a broker name, client identifier
    /// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
    /// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
    /// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
    /// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
    /// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
    /// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
    /// of 1883 is used.
    /// If you want to use websockets rather than TCP see below.
    ///
    client1 = mqtt.MqttClient(broker, '');
    client1.port = port;

    /// A websocket URL must start with ws:// or wss:// or Dart will throw an exception, consult your websocket MQTT broker
    /// for details.
    /// To use websockets add the following lines -:
    /// client.useWebSocket = true;
    /// client.port = 80;  ( or whatever your WS port is)
    /// Note do not set the secure flag if you are using wss, the secure flags is for TCP sockets only.

    /// Set logging on if needed, defaults to off
    client1.logging(on: true);

    /// If you intend to use a keep alive value in your connect message that is not the default(60s)
    /// you must set it here
    client1.keepAlivePeriod = 30;

    /// Add the unsolicited disconnection callback
    client1.onDisconnected = _onDisconnected1;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password, the default keepalive interval(60s)
    /// and clean session, an example of a specific one below.
    final mqtt.MqttConnectMessage connMess1 = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientIdentifier1)
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
        .withWillQos(mqtt.MqttQos.atMostOnce);
    print('[MQTT client] MQTT client connecting....');
    client1.connectionMessage = connMess1;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.

    try {
      await client1.connect(username, passwd);
    } catch (e) {
      print(e);
      _disconnect();
    }

    /// Check if we are connected
    if (client1.connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] connected');
      setState(() {
        connectionState1 = client1.connectionState;
      });
    } else {
      print('[MQTT client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client1.connectionState}');
      _disconnect1();
    }

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    subscription1 = client1.updates.listen(_onMessage1);

    _subscribeToTopic1("placa1/humedadambiente");
  }

  void _connect2() async {
    /// First create a client, the client is constructed with a broker name, client identifier
    /// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
    /// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
    /// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
    /// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
    /// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
    /// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
    /// of 1883 is used.
    /// If you want to use websockets rather than TCP see below.
    ///
    client2 = mqtt.MqttClient(broker, '');
    client2.port = port;

    /// A websocket URL must start with ws:// or wss:// or Dart will throw an exception, consult your websocket MQTT broker
    /// for details.
    /// To use websockets add the following lines -:
    /// client.useWebSocket = true;
    /// client.port = 80;  ( or whatever your WS port is)
    /// Note do not set the secure flag if you are using wss, the secure flags is for TCP sockets only.

    /// Set logging on if needed, defaults to off
    client2.logging(on: true);

    /// If you intend to use a keep alive value in your connect message that is not the default(60s)
    /// you must set it here
    client2.keepAlivePeriod = 30;

    /// Add the unsolicited disconnection callback
    client2.onDisconnected = _onDisconnected2;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password, the default keepalive interval(60s)
    /// and clean session, an example of a specific one below.
    final mqtt.MqttConnectMessage connMess2 = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientIdentifier2)
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
        .withWillQos(mqtt.MqttQos.atMostOnce);
    print('[MQTT client] MQTT client connecting....');
    client2.connectionMessage = connMess2;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.

    try {
      await client2.connect(username, passwd);
    } catch (e) {
      print(e);
      _disconnect2();
    }

    /// Check if we are connected
    if (client2.connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] connected');
      setState(() {
        connectionState2 = client2.connectionState;
      });
    } else {
      print('[MQTT client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client2.connectionState}');
      _disconnect2();
    }

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.

    subscription2 = client2.updates.listen(_onMessage2);

    _subscribeToTopic2("placa1/humedadsuelo");
  }


  void _disconnect() {
    print('[MQTT client] _disconnect()');
    client.disconnect();
    _onDisconnected();
  }
  void _disconnect1() {
    print('[MQTT client] _disconnect1()');
    client1.disconnect();
    _onDisconnected1();
  }
  void _disconnect2() {
    print('[MQTT client] _disconnect2()');
    client2.disconnect();
    _onDisconnected2();
  }

  void _onDisconnected() {
    print('[MQTT client] _onDisconnected');
    setState(() {
      //topics.clear();
      connectionState = client.connectionState;
      client = null;
      subscription.cancel();
      subscription = null;
    });
    print('[MQTT client] MQTT client disconnected');
  }
  void _onDisconnected1() {
    print('[MQTT client] _onDisconnected1');
    setState(() {
      //topics.clear();
      connectionState1 = client1.connectionState;
      client1 = null;
      subscription1.cancel();
      subscription1 = null;
    });
    print('[MQTT client] MQTT client disconnected');
  }
  void _onDisconnected2() {
    print('[MQTT client] _onDisconnected2');
    setState(() {
      //topics.clear();
      connectionState2 = client2.connectionState;
      client2 = null;
      subscription2.cancel();
      subscription2 = null;
    });
    print('[MQTT client] MQTT client disconnected');
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {

    print(event.length);
    final mqtt.MqttPublishMessage recMess =
    event[0].payload as mqtt.MqttPublishMessage;

    final String message =
    mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);


    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    print('[MQTT client] MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- ${message} -->');
    print(client.connectionState);
    print("[MQTT client] message with topic: ${event[0].topic} ");
    print("[MQTT client] message with message: ${message}");


    setState(() {
      _temp = double.parse(message);

    });
  }

  void _onMessage1(List<mqtt.MqttReceivedMessage> event) {

    print(event.length);
    final mqtt.MqttPublishMessage recMess1 =
    event[0].payload as mqtt.MqttPublishMessage;

    final String message1 =
    mqtt.MqttPublishPayload.bytesToStringAsString(recMess1.payload.message);


    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    print('[MQTT client] MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- ${message1} -->');
    print(client1.connectionState);
    print("[MQTT client] message with topic: ${event[0].topic} ");
    print("[MQTT client] message with message: ${message1}");


    setState(() {
      _huma= double.parse(message1);

    });
  }

  void _onMessage2(List<mqtt.MqttReceivedMessage> event) {

    print(event.length);
    final mqtt.MqttPublishMessage recMess2 =
    event[0].payload as mqtt.MqttPublishMessage;

    final String message2 =
    mqtt.MqttPublishPayload.bytesToStringAsString(recMess2.payload.message);


    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    print('[MQTT client] MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- ${message2} -->');
    print(client2.connectionState);
    print("[MQTT client] message with topic: ${event[0].topic} ");
    print("[MQTT client] message with message: ${message2}");


    setState(() {
      _hums = double.parse(message2);

    });
  }

}
