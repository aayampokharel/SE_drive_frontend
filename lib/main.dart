import 'package:flutter/material.dart';
import 'package:x/body_row.dart';

void main() {
  runApp(Drive());
}

class Drive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Drive demo"),
          ),
          body: DriveBody()),
    );
  }
}

class DriveBody extends StatelessWidget {
  const DriveBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BodyRow();
  }
}
