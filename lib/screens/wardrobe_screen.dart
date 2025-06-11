// screens/wardrobe_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import '../models/clothing_item.dart';
import '../services/wardrobe_service.dart';

class WardrobeScreen extends StatefulWidget {
  @override
  _WardrobeScreenState createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ClothingItem> _allItems = [];
  List<ClothingItem> _filteredItems = [];
  List<ClothingItem> _favoriteItems = [];
  String _selectedCategory = 'All';
  bool _isLoading = true;

  final List<String> _categories = [
    'All', 'Tops', 'Bottoms', 'Dresses', 'Outerwear', 'Accessories'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadWardrobe();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadWardrobe() async {
    setState(() => _isLoading = true);
    
    try {
      final items = await WardrobeService.getWardrobeItems();
      setState(() {
        _allItems = items;
        _filteredItems = items;
        _favoriteItems = items.where((item) => item.isFavorite).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error loading wardrobe: $e');
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filteredItems = category == 'All' 
          ? _allItems 
          : _allItems.where((item) => item.category == category).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF667eea), Colors.white],
            stops: [0.0, 0.2],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMyWardrobeTab(),
                    _buildOutfitsTab(),
                    _buildFavoritesTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        backgroundColor: Color(0xFF667eea),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Wardrobe',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${_allItems.length} items in your collection',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white, size: 28),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xFF667eea),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        tabs: [
          Tab(text: 'My Items'),
          Tab(text: 'Outfits'),
          Tab(text: 'Favorites'),
        ],
      ),
    );
  }

  Widget _buildMyWardrobeTab() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          _buildCategoryFilter(),
          SizedBox(height: 20),
          Expanded(
            child: _isLoading 
                ? _buildLoadingGrid()
                : _filteredItems.isEmpty
                    ? _buildEmptyState()
                    : _buildClothingGrid(_filteredItems),
          ),
        ],
      ),
    );
  }

  Widget _buildOutfitsTab() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Create & Manage Outfits',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.8,
              ),
              itemCount: 6, // Mock outfits
              itemBuilder: (context, index) => _buildOutfitCard(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: _favoriteItems.isEmpty
          ? _buildEmptyFavoritesState()
          : _buildClothingGrid(_favoriteItems),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          return GestureDetector(
            onTap: () => _filterByCategory(category),
            child: Container(
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF667eea) : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? Color(0xFF667eea) : Colors.grey[300]!,
                ),
              ),
              child: Text(
                category,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildClothingGrid(List<ClothingItem> items) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                  child: Image.network(
                    item.imageUrl,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item.category,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(
                            item.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: item.isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              items[index] = ClothingItem(
                                id: item.id,
                                name: item.name,
                                imageUrl: item.imageUrl,
                                category: item.category,
                                isFavorite: !item.isFavorite,
                              );
                              _favoriteItems = _allItems.where((i) => i.isFavorite).toList();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        itemCount: 6,
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No items found in this category.',
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildEmptyFavoritesState() {
    return Center(
      child: Text(
        'No favorite items yet.',
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildOutfitCard(int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
      child: Center(
        child: Text(
          'Outfit ${index + 1}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showAddItemDialog() {
    // Placeholder for add item dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Item'),
        content: Text('Add item functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    // Placeholder for search dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search'),
        content: Text('Search functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}