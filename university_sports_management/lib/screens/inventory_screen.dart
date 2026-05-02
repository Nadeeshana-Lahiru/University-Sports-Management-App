import 'package:flutter/material.dart';
import '../models/sports_item.dart';
import '../services/api_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late Future<List<SportsItem>> futureItems;

  @override
  void initState() {
    super.initState();
    // This calls the GET /api/items endpoint we defined in the service
    futureItems = ApiService().fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Equipment Inventory')),
      body: FutureBuilder<List<SportsItem>>(
        future: futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // While we haven't built the backend, this error is expected!
            return Center(child: Text("Error: ${snapshot.error}\n(Hint: Azure backend isn't live yet)"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No items found in database."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.sports_basketball)),
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Category: ${item.category}"),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${item.availableQuantity} / ${item.totalQuantity}", 
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                      const Text("Available", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() { futureItems = ApiService().fetchItems(); }),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}