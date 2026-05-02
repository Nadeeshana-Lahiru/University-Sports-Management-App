import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ReturnScreen extends StatefulWidget {
  const ReturnScreen({super.key});

  @override
  State<ReturnScreen> createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Mock data for now - This will come from your Transactions table later
  Map<String, dynamic>? transactionData;

  void _searchStudent() {
    // Phase 4: This will call your Azure API to search by RegNo
    setState(() {
      transactionData = {
        'RegNo': _searchController.text,
        'StudentName': 'Kavinda',
        'Item': 'Cricket Bat',
        'BorrowDate': '2026-05-02',
        'ImageUrl': 'https://via.placeholder.com/150', // Mock image
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Return Equipment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Enter Student Reg No",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchStudent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            if (transactionData != null) ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text("Active Transaction", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const Divider(),
                      Text("Student: ${transactionData!['StudentName']}"),
                      Text("Item: ${transactionData!['Item']}"),
                      Text("Borrowed on: ${transactionData!['BorrowDate']}"),
                      const SizedBox(height: 10),
                      
                      // Visual verification: Showing the saved ID photo[cite: 1]
                      const Text("Stored ID Image:"),
                      Image.network(transactionData!['ImageUrl'], height: 150),
                      
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                        onPressed: () {
                          // This will trigger the /api/return endpoint in the backend[cite: 1]
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Processing Return..."))
                          );
                        },
                        child: const Text("Confirm Return & Update Inventory"),
                      ),
                    ],
                  ),
                ),
              ),
            ] else 
              const Center(child: Text("Search for a student to see borrowed items.")),
          ],
        ),
      ),
    );
  }
}