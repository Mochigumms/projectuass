import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dessert_model.dart';

import 'dart:convert';

class DetailScreen extends StatefulWidget {
  final Dessert dessert;

  const DetailScreen({Key? key, required this.dessert}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;
  final String favoritesKey = 'favorites';

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  Future<void> checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(favoritesKey) ?? [];
    setState(() {
      isFavorite = favorites.contains(json.encode(widget.dessert.toJson()));
    });
  }

  Future<void> toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(favoritesKey) ?? [];
    
    final dessertJson = json.encode(widget.dessert.toJson());
    
    setState(() {
      if (isFavorite) {
        favorites.remove(dessertJson);
        isFavorite = false;
      } else {
        favorites.add(dessertJson);
        isFavorite = true;
      }
    });
    
    await prefs.setStringList(favoritesKey, favorites);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite ? 'Added to favorites' : 'Removed from favorites'
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              widget.dessert.image,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Spacer(),
                Text(
                  widget.dessert.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.dessert.description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${widget.dessert.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.pinkAccent : Colors.white,
                        size: 32,
                      ),
                      onPressed: toggleFavorite,
                    ),
                  ],
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}