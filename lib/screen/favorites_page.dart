import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  final Set<String> favorites;
  final Function(String) toggleFavorite;

  const FavoritesPage({
    super.key,
    required this.favorites,
    required this.toggleFavorite,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  String searchQuery = "";

  final List<Map<String, dynamic>> allFoods = [
    {
      "id": "1",
      "title": "Sate Padang",
      "price": "Rp. 20.000",
      "category": "Sate",
      "location": "Bandung, Indonesia",
      "desc": "Sate Padang pedas gurih khas Senayan.",
      "image": "../assets/satepadang1.jpg"
    },
    {
      "id": "2",
      "title": "Sate Taichan",
      "price": "Rp. 25.000",
      "category": "Sate",
      "location": "Jakarta, Indonesia",
      "desc": "Sate Taichan dengan sambel pedas manis gurih.",
      "image": "../assets/satetaichan1.jpg"
    },
    {
      "id": "3",
      "title": "Nasi Goreng Padang",
      "price": "Rp. 15.000",
      "category": "Nasi",
      "location": "Bandung, Indonesia",
      "desc": "Nasi Goreng Padang spesial dengan sayuran segar.",
      "image": "../assets/nasigoreng1.jpg"
    },
    {
      "id": "4",
      "title": "Ayam Goreng Khas Uni Ani",
      "price": "Rp. 18.000",
      "category": "Nasi",
      "location": "Surabaya, Indonesia",
      "desc": "Ayam goreng dengan sambel khas Uni Ani.",
      "image": "../assets/ayamgoreng1.jpg"
    },
    {
      "id": "5",
      "title": "Minuman Teh Manis & Jeruk Peras",
      "price": "Rp. 5.000",
      "category": "Minuman",
      "location": "Bandung, Indonesia",
      "desc": "Minuman segar agar tenggorokan terasa segar & nikmat.",
      "image": "../assets/minuman1.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter favorites
    final favoriteFoods = allFoods.where((food) {
      final isFav = widget.favorites.contains(food["id"]);
      final matchesSearch = food["title"]
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      return isFav && matchesSearch;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: (val) => setState(() => searchQuery = val),
            decoration: InputDecoration(
              hintText: "Search favorites",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
        Expanded(
          child: favoriteFoods.isEmpty
              ? const Center(child: Text("No favorites found"))
              : ListView.builder(
                  itemCount: favoriteFoods.length,
                  itemBuilder: (context, index) {
                    final food = favoriteFoods[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(food["image"],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, _, __) => Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey,
                                    child: const Icon(Icons.image_not_supported),
                                  )),
                        ),
                        title: Text(food["title"]),
                        subtitle: Text(food["location"]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            widget.toggleFavorite(food["id"]);
                          },
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              title: Text(food["title"],
                                  style:
                                      const TextStyle(fontWeight: FontWeight.bold)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(food["image"],
                                        height: 150,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, _, __) =>
                                            Container(
                                              height: 150,
                                              color: Colors.grey,
                                              child: const Icon(
                                                  Icons.image_not_supported),
                                            )),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(food["desc"]),
                                  const SizedBox(height: 10),
                                  Text(food["price"],
                                      style: const TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              actions: [
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    widget.toggleFavorite(food["id"]);
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Close",
                                      style: TextStyle(color: Colors.black)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
