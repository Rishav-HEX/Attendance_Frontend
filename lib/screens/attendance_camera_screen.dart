import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../services/api_service.dart';

class AttendanceCameraScreen extends StatefulWidget {
  const AttendanceCameraScreen({super.key});

  @override
  State<AttendanceCameraScreen> createState() =>
      _AttendanceCameraScreenState();
}

class _AttendanceCameraScreenState
    extends State<AttendanceCameraScreen> {

  CameraController? _cameraController;

  final api = ApiService();

  bool isCameraInitialized = false;

  bool isRecognizing = false;

  Timer? recognitionTimer;

List<dynamic> recognizedFaces = [];

String recognitionStatus =
    "Scanning Faces...";

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {

    final cameras =
        await availableCameras();

    final frontCamera =
        cameras.firstWhere(
      (camera) =>
          camera.lensDirection ==
          CameraLensDirection.front,
    );

    _cameraController =
        CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!
        .initialize();

    if (!mounted) return;

    setState(() {
      isCameraInitialized = true;
    });

    startAutoRecognition();
  }

  void startAutoRecognition() {

    recognitionTimer =
        Timer.periodic(

      const Duration(
        milliseconds: 500,
      ),

      (timer) {

        recognizeFace();
      },
    );
  }

Future<void> recognizeFace() async {

  if (isRecognizing) return;

  if (_cameraController == null) return;

  if (!_cameraController!.value.isInitialized) {
    return;
  }

  isRecognizing = true;

  try {

    final image =
        await _cameraController!
            .takePicture();

    final result =
        await api.recognizeFace(
      File(image.path),
    );

    print(result);
    print(
 _cameraController!
   .value
   .previewSize
);

    if (!mounted) return;

    if (result["success"] == true &&
        result["recognized"] != null &&
        result["recognized"].length > 0) {

      final student =
          result["recognized"][0];

setState(() {

  recognizedFaces =
      result["recognized"];

  recognitionStatus =
      "${recognizedFaces.length} Face(s) Detected";
});

    } else {

      setState(() {

        recognizedFaces = [];

        recognitionStatus =
        "No Face Detected";
      });
    }

  } catch (e) {

    print(
      "RECOGNITION ERROR => $e",
    );

    if (!mounted) return;

    setState(() {

      recognitionStatus =
          "Recognition Error";
    });

  } finally {

    isRecognizing = false;
  }
}

  @override
  void dispose() {

    recognitionTimer?.cancel();

    _cameraController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Live Attendance",
        ),
      ),

      body: !isCameraInitialized

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : Stack(

              children: [

                CameraPreview(
                  _cameraController!,
                ),
                ...recognizedFaces.map((face) {

  return Positioned(

    left: face["x1"].toDouble(),

    top: face["y1"].toDouble(),

    child: Container(

      width: (
        face["x2"] - face["x1"]
      ).toDouble(),

      height: (
        face["y2"] - face["y1"]
      ).toDouble(),

      decoration: BoxDecoration(

        border: Border.all(
          color: Colors.greenAccent,
          width: 3,
        ),

        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Align(

        alignment:
            Alignment.topCenter,

        child: Container(

          padding:
              const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),

          color: Colors.green,

          child: Text(

            face["name"],

            style:
                const TextStyle(
              color: Colors.white,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );

}).toList(),
                Positioned(

                  top: 20,
                  left: 20,
                  right: 20,

                  child: Container(

                    padding:
                        const EdgeInsets.all(
                      15,
                    ),

                    decoration:
                        BoxDecoration(

                      color: Colors.black54,

                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),
                    ),

                    child: Column(

                      children: [

                        Text(
  "${recognizedFaces.length}",
  style: const TextStyle(
    color: Colors.white,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  ),
),

const Text(
  "Faces Detected",
  style: TextStyle(
    color: Colors.white70,
  ),
),
                        const SizedBox(
                          height: 8,
                        ),

                        Text(

                          recognitionStatus,

                          textAlign:
                              TextAlign.center,

                          style:
                              const TextStyle(
                            color:
                                Colors.green,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(

                  bottom: 25,
                  left: 20,
                  right: 20,

                  child: Container(

                    padding:
                        const EdgeInsets.all(
                      12,
                    ),

                    decoration:
                        BoxDecoration(

                      color: Colors.black54,

                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),

                    child: const Text(

                      "Auto Recognition Running...",

                      textAlign:
                          TextAlign.center,

                      style: TextStyle(
                        color:
                            Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
  
}
