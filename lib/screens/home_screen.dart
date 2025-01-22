import 'package:flutter/material.dart';
import 'package:projectuas/screens/detail_screen.dart';
import '../data/dessert_data.dart';
import '../models/dessert_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  List<Dessert> _filteredDesserts = [];
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Cake', 'Pastry', 'Cookies'];

  @override
  void initState() {
    super.initState();
    _filteredDesserts = dessertList;
  }

  void _filterDesserts(String query) {
    setState(() {
      _filteredDesserts = dessertList
          .where((dessert) =>
              dessert.title.toLowerCase().contains(query.toLowerCase()) &&
              (_selectedCategory == 'All' ||
                  dessert.category == _selectedCategory))
          .toList();
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filterDesserts(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lagi cari dessert apa?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            SizedBox(height: 16),
            _buildSearchBar(),
            SizedBox(height: 12),
            _buildCategoryFilter(),
            SizedBox(height: 12),
            Expanded(child: _buildDessertList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: _filterDesserts,
      decoration: InputDecoration(
        hintText: 'Cari kue...',
        prefixIcon: Icon(Icons.search, color: Colors.brown),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((category) {
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () => _filterByCategory(category),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.pink[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.pink : Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _navigateToDetailScreen(Dessert dessert) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(dessert: dessert),
      ),
    );
  }

  Widget _buildDessertList() {
    return ListView.builder(
      itemCount: _filteredDesserts.length,
      itemBuilder: (context, index) {
        final dessert = _filteredDesserts[index];
        return _buildFoodCard(dessert);
      },
    );
  }

  Widget _buildFoodCard(Dessert dessert) {
    return GestureDetector(
      onTap: () => _navigateToDetailScreen(dessert),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(dessert.image),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.4), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                dessert.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(1, 1),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
