import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'camera_screen.dart';
import 'color_palette_screen.dart';
import 'admin_panel_screen.dart';
import 'wardrobe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeTab(),
    ColorPaletteScreen(),
    WardrobeScreen(),
    AdminPanelScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.palette), label: 'Colors'),
            BottomNavigationBarItem(icon: Icon(Icons.checkroom), label: 'Wardrobe'),
            BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Admin'),
          ],
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF667eea), Colors.white],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'StyleSuggest',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Discover your perfect colors',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 40),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildFeatureCard(
                        context,
                        'Camera Analysis',
                        'Take a photo to get personalized color suggestions',
                        Icons.camera_alt,
                        Color(0xFF4CAF50),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CameraScreen()),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        'Color Palette',
                        'Explore color combinations and palettes',
                        Icons.palette,
                        Color(0xFFFF9800),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ColorPaletteScreen()),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        'My Wardrobe',
                        'Browse and manage your virtual wardrobe',
                        Icons.checkroom,
                        Color(0xFF9C27B0),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WardrobeScreen()),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        'Style Tips',
                        'Get expert fashion advice and tips',
                        Icons.lightbulb,
                        Color(0xFF2196F3),
                        () => _showStyleTips(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String subtitle,
      IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, size: 30, color: color),
              ),
              SizedBox(height: 15),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStyleTips(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Style Tips',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildTipCard('Know Your Skin Tone', 'Understanding your undertones helps choose flattering colors'),
                    _buildTipCard('Color Harmony', 'Use complementary colors for striking combinations'),
                    _buildTipCard('Seasonal Colors', 'Each season has its perfect color palette'),
                    _buildTipCard('Texture Matters', 'Different fabrics reflect light differently'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}