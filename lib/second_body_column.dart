import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import 'package:x/map_for_post.dart';
import 'package:dio/dio.dart';

class SecondBodyColumn extends StatefulWidget {
  String headingValue;
  List<String> extensionList;

  SecondBodyColumn(this.headingValue, this.extensionList);

  @override
  State<SecondBodyColumn> createState() => _SecondBodyColumnState();
}

class _SecondBodyColumnState extends State<SecondBodyColumn> {
  double uploadProgress = 0.0;

  String urlString(String mapkey) {
    return mapForUploadDownload[mapkey]!["upload"]!;
  }

  void openFileSelector() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: widget.extensionList,
      withReadStream: true,
    );

    if (result == null) {
      print("No file selected");
      return;
    }
    var file = result.files.single;
    final fileName = file.name;
    final fileSize = file.size;
    var dio = Dio();
    FormData formData = FormData.fromMap({
      widget.headingValue: MultipartFile.fromStream(() {
        return file.readStream!;
      }, fileSize, filename: fileName),
    });
    dio.options.headers = {
      'Content-Type':
          'multipart/form-data', // Explicitly set, though it's often automatic for FormData
      // Replace with the actual token if needed
    };

    print("💦");
    print(dio.options.headers);
    print("💦");

   var response= await dio.post(
      urlString(widget.headingValue),
      data: formData,
      onSendProgress: (int sent, int total) {
        print(sent/total);
      },
    );
  print("hello");
  }

  @override
  Widget build(BuildContext context) { 
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          color: Colors.white,
          child: Row(
            children: [
              Expanded(child: Center(child: Text(widget.headingValue))),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    openFileSelector();
                  },
                  icon: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
        if (uploadProgress > 0)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LinearProgressIndicator(
              value: uploadProgress,
              minHeight: 5,
            ),
          ),
      ],
    );
  }
}
