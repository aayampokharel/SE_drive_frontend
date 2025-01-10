import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:x/Logic/upload.dart';

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
  double streamingResponseProgress = 0.0;

  void setStateForUploadPercent(num totalBytesTransferred, num fileSize) {
    setState(() {
      uploadProgress = totalBytesTransferred / fileSize * 0.5;
    });
    print(uploadProgress);
  }

//   var dio = Dio();
  //   FormData formData = FormData.fromMap({
  //     widget.headingValue: MultipartFile.fromStream(() {
  //       return file.readStream!;
  //     }, fileSize, filename: fileName),
  //   });
  //   dio.options.headers = {
  //     'Content-Type':
  //         'multipart/form-data', // Explicitly set, though it's often automatic for FormData
  //     // Replace with the actual token if needed
  //   };

  //  var response= await dio.post(
  //     urlString(widget.headingValue),
  //     data: formData,
  //     onSendProgress: (int sent, int total) {
  //       print(sent/total);
  //     },
  //   );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(widget.headingValue),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    openFileSelector(setStateForUploadPercent,
                        widget.headingValue, widget.extensionList);
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
