import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:x/map_for_post.dart';
import 'package:dio/dio.dart';

//@ second body column is the column covering most of the body , the firstcolumn consists of text,videos , etc tab inside inkwell whereas this consists of all the files for that selected tab displays it , can add new file , etc '
class SecondBodyColumn extends StatefulWidget {
  String headingValue;
  List<String> extensionList;

  SecondBodyColumn(this.headingValue, this.extensionList);

  @override
  State<SecondBodyColumn> createState() => _SecondBodyColumnState();
}

class _SecondBodyColumnState extends State<SecondBodyColumn> {
  Uri urlFunction(String mapkey) {
    return Uri.parse(mapForUploadDownload[mapkey]!["upload"]!);
  }

  String urlString(String mapkey) {
    return mapForUploadDownload[mapkey]!["upload"]!;
  }

  void openFileSelector() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: widget.extensionList,
      withData: true, //this is for flutter web where no access to path .
    );
    if (file == null) {
      print("no file selected ");
      return;
    }
    final fileName = file.files.single.name;
    final fileBytes = file.files.single.bytes;
    if (fileBytes != null) {
      // var result =
      //     http.MultipartRequest("POST", urlFunction(widget.headingValue));
//@ creating Dio instance .
      var dio = Dio();
      //@intializing formdata for file .
      FormData fileAsFormData = FormData.fromMap({
        widget.headingValue:
            MultipartFile.fromBytes(fileBytes, filename: fileName)
      });
//@ response with dio instance .
      Response response = await dio.post(
        urlString(
          widget.headingValue,
        ),
        data: fileAsFormData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      // result.files.add(http.MultipartFile.fromBytes(
      //     widget.headingValue, fileBytes,
      //     filename: fileName));

      // var response = await result.send();
      if (response.statusCode == 200) {
        print("success");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      Container(
        color: Colors.white,
        child: Row(
          //  mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: Center(child: Text(widget.headingValue))),
            Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () {
                      openFileSelector();
                    },
                    icon: Icon(Icons.add)))
          ],
        ),
      ),
    ]);
  }
}
