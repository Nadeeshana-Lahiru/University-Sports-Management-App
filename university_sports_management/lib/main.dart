import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'screens/checkout_screen.dart'; // We will create this next

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Obtain a list of the available cameras on the device.[cite: 1]
  cameras = await availableCameras();
  
  runApp(const MaterialApp(
    home: CheckoutScreen(),
  ));
}