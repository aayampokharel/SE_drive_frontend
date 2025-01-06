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
      withData: false,
      withReadStream: true,
    );

    if (result == null) {
      print("No file selected");
      return;
    }
    var file = result.files.single;
    final fileName = file.name;
    final fileSize = file.size;

    // Create a custom stream for chunking
    Stream<List<int>> customChunkedStream(
        Stream<List<int>> sourceStream, int chunkSize) async* {
      final buffer = <int>[]; // Temporary storage for partial chunks

      await for (final chunk in sourceStream) {
        buffer.addAll(chunk); // Add incoming data to the buffer

        // Emit full chunks
        while (buffer.length >= chunkSize) {
          yield buffer.sublist(0, chunkSize); // Emit a full chunk
          buffer.removeRange(
              0, chunkSize); // Remove emitted data from the buffer
        }
      }

      // Emit any remaining data as the last chunk
      if (buffer.isNotEmpty) {
        yield buffer;
      }
    }

    // Make the file stream broadcastable before passing it to customChunkedStream
    var fileReadStream = result.files.single.readStream!.asBroadcastStream();

    // Now, listen to the stream just once
    double totalBytesTransferred = 0;
    var customStream =
        customChunkedStream(fileReadStream, 512 * 1024); // 512 KB chunk size
    customStream.listen((chunk) {
      totalBytesTransferred += chunk.length;
      print((totalBytesTransferred / fileSize).toStringAsFixed(4));
    });

    // Prepare the request to upload the file
    var request = http.MultipartRequest(
        "POST", Uri.parse(urlString(widget.headingValue)));
    var multipartFile = http.MultipartFile(
        widget.headingValue, fileReadStream, fileSize,
        filename: fileName);

    request.files.add(multipartFile);
    final httpClient = http.Client();
    final response = await httpClient.send(request);

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }

    print("File uploaded successfully");
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

  //   print("💦");
  //   print(dio.options.headers);
  //   print("💦");

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
