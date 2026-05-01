import 'dart:io';
import 'package:flutter/material.dart';
import 'camera_screen.dart';
import '../main.dart'; // To access the cameras list

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? selectedItem;
  String? imagePath;
  
  // These controllers will be auto-filled by Azure AI in a later step
  final TextEditingController _regNoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // Mock list of items - later we will fetch this from your Azure SQL database
  final List<String> sportsItems = ['Cricket Bat', 'Football', 'Badminton Racket', 'Table Tennis Bat'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Equipment Check-out')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("1. Select Equipment", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              hint: const Text("Choose an item"),
              value: selectedItem,
              items: sportsItems.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedItem = val),
            ),
            
            const SizedBox(height: 20),
            const Text("2. Student Identification", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            // Image Preview Area
            Center(
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: imagePath == null
                    ? const Center(child: Text("No ID Photo Captured"))
                    : Image.file(File(imagePath!), fit: BoxFit.cover),
              ),
            ),
            
            ElevatedButton.icon(
              onPressed: () async {
                // Navigate to camera and wait for the result (the image path)
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(camera: cameras.first),
                  ),
                );

                if (result != null) {
                  setState(() => imagePath = result);
                  // Phase 2: In the next lesson, we'll trigger Azure AI here[cite: 1]
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Photo captured! Ready for AI extraction.")),
                  );
                }
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text("Capture Student ID"),
            ),

            const SizedBox(height: 20),
            // These fields remain read-only for now until we connect Azure AI Document Intelligence[cite: 1]
            TextField(
              controller: _regNoController,
              decoration: const InputDecoration(labelText: "Registration Number", hintText: "Waiting for AI..."),
              readOnly: true,
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Student Name", hintText: "Waiting for AI..."),
              readOnly: true,
            ),
            
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                onPressed: (imagePath != null && selectedItem != null) ? () {
                  // Submit logic for Phase 3[cite: 1]
                } : null,
                child: const Text("Confirm Check-out"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}