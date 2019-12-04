import 'package:flutter/material.dart';
import 'package:logincloud/loginemail.dart';
import 'package:syncfusion_flutter_core/core.dart';



void main() {
  SyncfusionLicense.registerLicense(null);

  runApp(
    MaterialApp(
      title: 'App Agrino',
      home: LoginPage(),
    ),
  );
}

