import 'package:flutter/material.dart';

Widget foodCard(Map<String, dynamic> food) {
  return Container(
    width: 150,
    margin: const EdgeInsets.only(right: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: Image.asset(food["image"],
              height: 100,
              width: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, _, __) => Container(
                    height: 100,
                    width: 150,
                    color: Colors.grey,
                    child: const Icon(Icons.image_not_supported),
                  )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(food["title"],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(food["price"], style: const TextStyle(color: Colors.orange)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget recommendedCard(Map<String, dynamic> food) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
          child: Image.asset(food["image"],
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, _, __) => Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey,
                    child: const Icon(Icons.image_not_supported),
                  )),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(food["title"],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Row(
                  children: List.generate(
                      5,
                      (index) => const Icon(Icons.star,
                          color: Colors.orange, size: 16)),
                ),
                const SizedBox(height: 5),
                Text(food["location"],
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
