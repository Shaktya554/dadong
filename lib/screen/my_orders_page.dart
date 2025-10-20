import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyOrdersPage extends StatefulWidget {
  final List<Map<String, dynamic>> orders;

  const MyOrdersPage({super.key, required this.orders});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  late List<Map<String, dynamic>> localOrders;

  @override
  void initState() {
    super.initState();
    // Buat salinan lokal supaya aman dimodifikasi (hindari mengubah widget.orders langsung)
    localOrders = widget.orders.map((o) {
      final copy = Map<String, dynamic>.from(o);
      // Pastikan kunci yang penting ada dan dalam tipe yang benar
      if (copy["qty"] == null) {
        copy["qty"] = 1;
      } else {
        // jika ada, pastikan integer
        final v = copy["qty"];
        if (v is String) {
          copy["qty"] = int.tryParse(v) ?? 1;
        } else if (v is int) {
          // ok
        } else {
          copy["qty"] = 1;
        }
      }
      if (copy["price"] == null) copy["price"] = "Rp 0";
      return copy;
    }).toList();
  }

  int parsePrice(dynamic price) {
    // Harga bisa datang sebagai String seperti "Rp 20.000" atau sebagai int
    if (price == null) return 0;
    if (price is int) return price;
    final s = price.toString();
    final digits = s.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  void incrementQty(int index) {
    setState(() {
      final current = localOrders[index]["qty"];
      final qty = (current is int) ? current : int.tryParse(current.toString()) ?? 1;
      localOrders[index]["qty"] = qty + 1;
    });
  }

  void decrementQty(int index) {
    final current = localOrders[index]["qty"];
    final qty = (current is int) ? current : int.tryParse(current.toString()) ?? 1;
    if (qty <= 1) return;
    setState(() {
      localOrders[index]["qty"] = qty - 1;
    });
  }

  void removeItem(int index) {
    setState(() {
      localOrders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    // Hitung total harga dan jumlah item (qty)
    final totalHarga = localOrders.fold<int>(
      0,
      (sum, order) {
        final harga = parsePrice(order["price"]);
        final qtyRaw = order["qty"];
        final qty = (qtyRaw is int) ? qtyRaw : int.tryParse(qtyRaw.toString()) ?? 1;
        return sum + harga * qty;
      },
    );
    final totalItemCount = localOrders.fold<int>(
      0,
      (sum, order) {
        final qtyRaw = order["qty"];
        final qty = (qtyRaw is int) ? qtyRaw : int.tryParse(qtyRaw.toString()) ?? 1;
        return sum + qty;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pesanan Saya",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: localOrders.isEmpty
          ? const Center(
              child: Text(
                "Belum ada pesanan.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: localOrders.length,
                    itemBuilder: (context, index) {
                      final order = localOrders[index];
                      final qtyRaw = order["qty"];
                      final qty = (qtyRaw is int) ? qtyRaw : int.tryParse(qtyRaw.toString()) ?? 1;
                      final hargaSatuan = parsePrice(order["price"]);
                      final subtotal = hargaSatuan * qty;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: _buildImage(order["image"]),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order["title"]?.toString() ?? '-',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Harga: ${order["price"]}",
                                      style: const TextStyle(color: Colors.orange),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Subtotal: ${numberFormat.format(subtotal)}",
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),

                              // quantity controls + delete
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle, color: Colors.orange),
                                        onPressed: () => decrementQty(index),
                                      ),
                                      Text(
                                        "$qty",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle, color: Colors.orange),
                                        onPressed: () => incrementQty(index),
                                      ),
                                    ],
                                  ),
                                  // tombol hapus kecil
                                  TextButton.icon(
                                    onPressed: () => removeItem(index),
                                    icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                                    label: const Text(
                                      "Hapus",
                                      style: TextStyle(color: Colors.red, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // bagian total dan aksi
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Jumlah Item:",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "$totalItemCount item",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Harga:",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            numberFormat.format(totalHarga),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  localOrders.clear();
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                              ),
                              child: const Text("Hapus Semua"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  // placeholder checkout action
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Proses checkout belum diimplementasikan"),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,   // warna latar tombol
                                  foregroundColor: Colors.white,    // warna teks (font)
                                ),
                                child: const Text("Checkout"),
                              ),

                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildImage(dynamic imageField) {
    // imageField boleh null, String path, atau network url. Tangani aman.
    if (imageField == null) {
      return const Icon(Icons.fastfood, color: Colors.orange, size: 40);
    }
    final s = imageField.toString();
    // jika terlihat seperti URL http/https tampil network, kalau tidak coba asset
    if (s.startsWith('http://') || s.startsWith('https://')) {
      return Image.network(s, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
        return const Icon(Icons.fastfood, color: Colors.orange, size: 40);
      });
    } else {
      return Image.asset(s, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
        return const Icon(Icons.fastfood, color: Colors.orange, size: 40);
      });
    }
  }
}
