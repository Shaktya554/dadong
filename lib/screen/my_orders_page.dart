import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  final List<Map<String, dynamic>> orders = const [
    {
      "title": "Ayam Goreng Khas Uni Ani",
      "price": "Rp 18.000",
      "status": "Selesai",
      "date": "03 Okt 2025"
    },
    {
      "title": "Sate Padang",
      "price": "Rp 20.000",
      "status": "Sedang Dikirim",
      "date": "04 Okt 2025"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.orange,
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                "Belum ada pesanan.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(
                      Icons.receipt_long,
                      color: Colors.orange,
                      size: 32,
                    ),
                    title: Text(
                      order["title"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Tanggal: ${order["date"]}\nStatus: ${order["status"]}",
                    ),
                    trailing: Text(
                      order["price"],
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
