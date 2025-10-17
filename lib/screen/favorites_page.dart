import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  final List<Map<String, dynamic>> favoriteFoods = const [
    {
      "title": "Sate Taichan",
      "price": "Rp 25.000",
      "image": "../assets/satetaichan1.jpg",
      "location": "Jakarta, Indonesia"
    },
    {
      "title": "Nasi Goreng Padang",
      "price": "Rp 15.000",
      "image": "../assets/nasigoreng1.jpg",
      "location": "Bandung, Indonesia"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.orange,
      ),
      body: favoriteFoods.isEmpty
          ? const Center(
              child: Text(
                "Belum ada makanan favorit.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: favoriteFoods.length,
              itemBuilder: (context, index) {
                final food = favoriteFoods[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        food["image"],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, _, __) => Container(
                          color: Colors.grey[300],
                          width: 60,
                          height: 60,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                    title: Text(
                      food["title"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(food["location"]),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          food["price"],
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Icon(Icons.favorite, color: Colors.red, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
