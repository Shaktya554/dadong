import 'package:flutter/material.dart';
import '../widgets/food_card.dart';

class FoodListPage extends StatefulWidget {
  const FoodListPage({super.key});

  @override
  State<FoodListPage> createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  String selectedCategory = "Semua";
  String searchQuery = "";

  final List<Map<String, dynamic>> foods = [
    {
      "title": "Sate Padang",
      "price": "Rp. 20.000",
      "category": "Sate",
      "location": "Bandung, Indonesia",
      "desc": "Sate Padang pedas gurih khas Senayan.",
      "image": "../assets/satepadang1.jpg"
    },
    {
      "title": "Sate Taichan",
      "price": "Rp. 25.000",
      "category": "Sate",
      "location": "Jakarta, Indonesia",
      "desc": "Sate Taichan dengan sambel pedas manis gurih.",
      "image": "../assets/satetaichan1.jpg"
    },
    {
      "title": "Nasi Goreng Padang",
      "price": "Rp. 15.000",
      "category": "Nasi",
      "location": "Bandung, Indonesia",
      "desc": "Nasi Goreng Padang spesial dengan sayuran segar.",
      "image": "../assets/nasigoreng1.jpg"
    },
    {
      "title": "Ayam Goreng Khas Uni Ani",
      "price": "Rp. 18.000",
      "category": "Nasi",
      "location": "Surabaya, Indonesia",
      "desc": "Ayam goreng dengan sambel khas Uni Ani.",
      "image": "../assets/ayamgoreng1.jpg"
    },
    {
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
    final filteredFoods = foods.where((food) {
      final matchCategory =
          (selectedCategory == "Semua" || food["category"] == selectedCategory);
      final matchSearch = food["title"]
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text("Food List",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["Semua", "Sate", "Minuman", "Nasi"].map((cat) {
                  final isSelected = selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: Colors.orange,
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold),
                      onSelected: (val) =>
                          setState(() => selectedCategory = cat),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredFoods.length,
                itemBuilder: (context, index) {
                  final food = filteredFoods[index];
                  return GestureDetector(
                    onTap: () => showFoodDialog(context, food),
                    child: foodCard(food),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text("Food Recommended",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Column(
              children: filteredFoods.map((food) {
                return GestureDetector(
                  onTap: () => showFoodDialog(context, food),
                  child: recommendedCard(food),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}

void showFoodDialog(BuildContext context, Map<String, dynamic> food) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(food["title"],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(food["image"],
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, _, __) => Container(
                        height: 150,
                        color: Colors.grey,
                        child: const Icon(Icons.image_not_supported),
                      )),
            ),
            const SizedBox(height: 10),
            Text(food["desc"]),
            const SizedBox(height: 10),
            Text(food["price"],
                style: const TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () => Navigator.pop(context),
            child: const Text("Order"),
          )
        ],
      );
    },
  );
}
