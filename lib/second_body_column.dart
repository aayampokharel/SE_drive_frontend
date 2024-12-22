import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

//@ second body column is the column covering most of the body , the firstcolumn consists of text,videos , etc tab inside inkwell whereas this consists of all the files for that selected tab displays it , can add new file , etc '
class SecondBodyColumn extends StatefulWidget {
  String headingValue;
  SecondBodyColumn(this.headingValue);

  @override
  State<SecondBodyColumn> createState() => _SecondBodyColumnState();
}

class _SecondBodyColumnState extends State<SecondBodyColumn> {
  openFileSelector(List<String> type, String fieldName) async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      allowedExtensions: type,
      withData: true, //this is for flutter web where no access to path .
    );
    if (file == null) {
      print("no file seelected ");
      return;
    }
    final fileName = file.files.single.name;
    final fileBytes = file.files.single.bytes;

    // http.MultipartFile(field, stream, length)
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
                child: IconButton(onPressed: null, icon: Icon(Icons.add)))
          ],
        ),
      ),
    ]);
  }
}
