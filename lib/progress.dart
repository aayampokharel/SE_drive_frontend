
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:x/map_for_post.dart';

String urlString(String mapkey) {
  return mapForUploadDownload[mapkey]!["upload"]!;
}

void openFileSelector(Function(num, num) setStateForUploadPercent,
    String headingValue, List<String> extensionList) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: extensionList,
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
        buffer.removeRange(0, chunkSize); // Remove emitted data from the buffer
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
    setStateForUploadPercent(totalBytesTransferred, fileSize);
  });

  // Prepare the request to upload the file
  var request =
  http.MultipartRequest("POST", Uri.parse(urlString(headingValue)));
  var multipartFile = http.MultipartFile(headingValue, fileReadStream, fileSize,
      filename: fileName);

  request.files.add(multipartFile);

  final httpClient = http.Client();
  var streamedResponse = await httpClient.send(request);
  var newFileSize = streamedResponse.headers['File-Size'];

  // Listen to the response stream for incoming chunks
  print(streamedResponse.headersSplitValues);
  streamedResponse.stream.listen(
        (chunkFromServer) {
      print(newFileSize);
      print("Chunk received: ${chunkFromServer.length}");
    },
    onDone: () {
      print(newFileSize);
      print("Finished processing all chunks.");
    },
    onError: (error) {
      print("Error occurred: $error");
    },
    cancelOnError: true,
  );
  print("File uploaded successfully");
}

//final responseFuture = httpClient.send(request);

// final responseFuture = httpClient
//     .send(request); // Process the response stream as chunks arrive
// final streamedResponse = await responseFuture;

// print("💦💦💦💦");
// print(streamedResponse);
// print("💦💦💦💦");
// streamedResponse.stream.listen((responseStream) {
//   print("done ");
// });


