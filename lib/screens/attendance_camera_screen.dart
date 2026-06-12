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

  String recognizedName =
      "Waiting For Face...";

  String recognitionStatus =
      "Camera Started";

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
        seconds: 2,
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

    if (!mounted) return;

    if (result["success"] == true &&
        result["recognized"] != null &&
        result["recognized"].length > 0) {

      final student =
          result["recognized"][0];

      setState(() {

        recognizedName =
            student["name"];

        recognitionStatus =
            "Attendance Marked ✅";
      });

    } else {

      setState(() {

        recognizedName =
            "Unknown Face";

        recognitionStatus =
            "Face Not Registered";
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

                          recognizedName,

                          textAlign:
                              TextAlign.center,

                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
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
