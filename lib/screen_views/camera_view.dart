import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import '../constants/local_keys.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> cameras;
  CameraController? controller;
  bool isCameraInitialized = false;
  late SharedPreferences preferences;
  Position? position;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
    position = await getCurrentLocation();
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    await controller!.initialize();
    setState(() {
      isCameraInitialized = true;
    });
  }

  Future<void> takePicture() async {
    if (!controller!.value.isInitialized) return;
    Vibration.vibrate();
    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/Pictures';
    await Directory(dirPath).create(recursive: true);
    final String filePath = join(
      dirPath,
      '${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    try {
      final XFile picture = await controller!.takePicture();
      await picture.saveTo(filePath);
      await preferences.setString(LocalKeys.lastPicturePath, filePath);
      await preferences.setString(
        LocalKeys.locationLatitude,
        (position?.latitude ?? "").toString(),
      );
      await preferences.setString(
        LocalKeys.locationLongitude,
        (position?.longitude ?? "").toString(),
      );
      Get.back();
      // ScaffoldMessenger.of(
      //   Get.context!,
      // ).showSnackBar(SnackBar(content: Text("Picture saved: $filePath")));
    } catch (e) {
      ScaffoldMessenger.of(
        Get.context!,
      ).showSnackBar(SnackBar(content: Text("Error taking picture: $e")));
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Camera")),
      body: Stack(
        children: [
          SizedBox(height: Get.height - 60, child: CameraPreview(controller!)),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: takePicture,
                child: Icon(Icons.camera),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDialog(
        'Location Services Disabled',
        "Please enable the device GPS Location.",
      );
      return null;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationServiceDialog(
          "Location permission error",
          "Location permission is required. Please enable it in your device settings.",
        );
        return null;
      }
    }

    // If permission is granted, get the current position
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return await Geolocator.getCurrentPosition();
    }
  }

  void _showLocationServiceDialog(String title, String msg) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: [
            TextButton(
              child: Text('Enable'),
              onPressed: () {
                Geolocator.openLocationSettings();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
