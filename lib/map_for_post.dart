Map<String, Map<String, String>> mapForUploadDownload = {
  "Photo": {
    "upload": "http://10.0.2.2:41114/uploadphotos",
    "download": "http://localhost:8080/downloadphotos",
  },
  "Video": {
    "upload": "http://10.0.2.2:41114/uploadvideos",
    "download": "http://localhost:8080/downloadvideos",
  },
  "Audio": {
    "upload": "http://localhost:8080/uploadaudios",
    "download": "http://localhost:8080/downloadaudios",
  },
  "Text": {
    "upload": "http://localhost:8080/uploadtexts",
    "download": "http://localhost:8080/downloadtexts",
  },
  "PDF": {
    "upload": "http://localhost:8080/uploadpdfs",
    "download": "http://localhost:8080/downloadpdfs",
  },
};
