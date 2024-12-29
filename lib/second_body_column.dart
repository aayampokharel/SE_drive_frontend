import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;

import 'package:x/map_for_post.dart';

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
    // Assuming this is where your server URL is defined
    return mapForUploadDownload[mapkey]!["upload"]!;
  }

  void openFileSelector() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: widget.extensionList,
      withData: true, // This is for Flutter Web where no access to file path
    );

    if (file == null) {
      print("No file selected");
      return;
    }

    final fileName = file.files.single.name;
    final fileBytes = file.files.single.bytes;

    if (fileBytes != null) {
      var formData = html.FormData();
      formData.appendBlob(
          widget.headingValue, html.Blob([fileBytes]), fileName);

      // Create an XMLHttpRequest to track progress manually
      html.HttpRequest request = html.HttpRequest();
      request
        ..open('POST', urlString(widget.headingValue))
        ..onProgress.listen((event) {
          if (event.lengthComputable) {
            setState(() {
              uploadProgress = event.loaded! / event.total!;
            });
            print('Progress: ${(uploadProgress * 100).toStringAsFixed(2)}%');
          }
        })
        ..onLoad.listen((event) {
          if (request.status == 200) {
            print('Upload successful');
          } else {
            print('Upload failed with status: ${request.status}');
          }
        })
        ..send(formData);
    }
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
