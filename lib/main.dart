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
    //@ BodyRow is the main body of the file . This body consists of a row with 2 columns one small as choose option between :audio,video,text, etc another column covering 80percent of area displays those files that are uploaded in the section .
    return BodyRow();
  }
}
