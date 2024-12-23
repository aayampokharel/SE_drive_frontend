import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:x/second_body_column.dart';

class BodyRow extends StatefulWidget {
  const BodyRow({super.key});

  @override
  State<BodyRow> createState() => _BodyRowState();
}

class _BodyRowState extends State<BodyRow> {
  var headingValue = "VIDEO";
  List<String> extensionList = ["mp4"];
  FileType fileType = FileType.video;
  void setStateForHeadingValue(String text) {
    //! setstate ma tanne and then supply those listextension and filetype from ClickableContent(a, b, c, d);;;;;;;
    setState(() {
      headingValue = text;
      switch (text) {
        case "Photo":
          extensionList = ["jpg", "png"];
          fileType = FileType.image;
          break;
        case "Video":
          extensionList = ["mp4", "mkv", "avi"];
          fileType = FileType.video;
          break;
        case "Audio":
          extensionList = ["mp3", "wav", "ogg"];
          fileType = FileType.audio;
          break;
        case "PDF":
          extensionList = ["pdf"];
          fileType = FileType.custom;
          break;
        case "Text":
          extensionList = ["txt", "md"];
          fileType = FileType.custom;
          break;
        default:
          extensionList = [];
          fileType = FileType.any;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: Colors.red,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FlutterLogo(
                  size: 50,
                ),
              ),
              SizedBox(height: 20),
              ClickableContent("Photo", setStateForHeadingValue),
              ClickableContent("Video", setStateForHeadingValue),
              ClickableContent("Audio", setStateForHeadingValue),
              ClickableContent("Text", setStateForHeadingValue),
              ClickableContent("PDF", setStateForHeadingValue),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.green,
            child: SecondBodyColumn(headingValue, extensionList, fileType),
          ),
        ),
      ],
    );
  }
}

class ClickableContent extends StatefulWidget {
  String str;
  void Function(String) setStateFunction;
  ClickableContent(this.str, this.setStateFunction);

  @override
  State<ClickableContent> createState() => _ClickableContentState();
}

class _ClickableContentState extends State<ClickableContent> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.setStateFunction(widget.str);
        },
        child: Container(padding: EdgeInsets.all(10), child: Text(widget.str)));
  }
}
