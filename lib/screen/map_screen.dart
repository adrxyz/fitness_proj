import 'package:flutter/material.dart';
import 'package:fitness_proj/widgets/color_constant.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Placeholder data for jogging stats
  final String distance = "8.45";
  final String duration = "0:45:12";
  final String pace = "5:21";

  // State for filter chips (to simulate selection)
  String? _selectedRouteType;
  String? _selectedLength;
  String? _selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNearBlack,
      appBar: AppBar(
        title: const Text(
          'SHADOW RUNNER',
          style: TextStyle(color: kAccentGold, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        backgroundColor: kNearBlack,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section: Your location, Filters, and Map
            _buildMapSection(),

            // Running Stats Display (moved below the map section)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('DISTANCE (KM)', distance, 'km', Icons.directions_run),
                  _buildStatCard('DURATION', duration, '', Icons.timer),
                  _buildStatCard('AVG PACE', pace, '/km', Icons.speed),
                ],
              ),
            ),

            // Start Run Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  print("Starting a new run!");
                },
                icon: const Icon(Icons.play_arrow, color: kNearBlack),
                label: const Text(
                  'INITIATE TRACKING',
                  style: TextStyle(color: kNearBlack, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentGold,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- New Widget Builders for Map-like UI ---

  Widget _buildMapSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            children: [
              // "Your location" and Bookmark
              Row(
                children: [
                  const Icon(Icons.location_on, color: kPrimaryMaroon, size: 20),
                  const SizedBox(width: 5),
                  const Text( // Removed .withOpacity()
                    'Your location',
                    style: TextStyle(color: kOffWhite, fontSize: 14),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: kOffWhite),
                  const Spacer(),
                  const Icon(Icons.bookmark_border, color: kOffWhite),
                ],
              ),
              const SizedBox(height: 10),
              // Horizontal Filter Chips for Map (Routes, Length, Difficulty, etc.)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildMapFilterChip('Routes', Icons.directions_bike, _selectedRouteType, (value) {
                      setState(() {
                        _selectedRouteType = value;
                      });
                    }, ['Bike', 'Run', 'Walk']),
                    _buildMapFilterChip('Length', Icons.timeline, _selectedLength, (value) {
                      setState(() {
                        _selectedLength = value;
                      });
                    }, ['Short', 'Medium', 'Long']),
                    _buildMapFilterChip('Difficulty', Icons.local_fire_department, _selectedDifficulty, (value) {
                      setState(() {
                        _selectedDifficulty = value;
                      });
                    }, ['Easy', 'Medium', 'Hard']),
                    _buildMapFilterChip('Elevation', Icons.landscape),
                    _buildMapFilterChip('Surface', Icons.texture),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Actual Map and Overlays
        Container(
          height: 400, // Slightly taller map area
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: kDarkGrey,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: kPrimaryMaroon, width: 2),
            boxShadow: [
              BoxShadow(
                color: kPrimaryMaroon, // Removed .withOpacity(0.3)
                blurRadius: 10,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Base Map Image (dark, stylized)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/map_background_dark.png', // A dark map background image
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  colorBlendMode: BlendMode.darken, // Make it darker
                // Removed .withOpacity(0.4)
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    print('Create new route');
                  },
                  backgroundColor: kAccentGold,
                  icon: const Icon(Icons.edit_location, color: kNearBlack),
                  label: const Text('Create Route', style: TextStyle(color: kNearBlack)),
                ),
              ),
              // Overlay icons on the right side
              Positioned(
                right: 10,
                top: 50, // Adjust as needed
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.layers, color: kOffWhite, size: 28), // Removed .withOpacity(0.8)
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.terrain, color: kOffWhite, size: 28), // Removed .withOpacity(0.8)
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.threed_rotation, color: kOffWhite, size: 28), // Removed .withOpacity(0.8)
                      onPressed: () {},
                    ),
                    // ... more map interaction icons
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        // Route Suggestion Card
        _buildRouteSuggestionCard(),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '6 routes',
              style: const TextStyle(color: kOffWhite, fontSize: 16, fontWeight: FontWeight.bold), // Removed .withOpacity(0.8)
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapFilterChip(String label, IconData icon, [String? selectedValue, ValueChanged<String?>? onSelected, List<String>? options]) {
    if (options != null && onSelected != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue,
            hint: Chip(
              avatar: Icon(icon, color: kAccentGold, size: 18),
              label: Text(label, style: const TextStyle(color: kOffWhite, fontSize: 13)),
              backgroundColor: kDarkGrey, // Removed .withOpacity(0.8)
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: kPrimaryMaroon, width: 1.5),
              ),
            ),
            dropdownColor: kDarkGrey,
            icon: const Icon(Icons.arrow_drop_down, color: kAccentGold),
            onChanged: (String? newValue) {
              onSelected(newValue);
            },
            items: [
              DropdownMenuItem<String>( // Option to clear selection
                value: null,
                child: Text('All $label', style: const TextStyle(color: kOffWhite)), // Removed .withOpacity(0.7)
              ),
              ...options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(color: kOffWhite)),
                );
              }).toList(),
            ],
          ),
        ),
      );
    } else {
      // Non-dropdown chips
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Chip(
          avatar: Icon(icon, color: kAccentGold, size: 18),
          label: Text(label, style: const TextStyle(color: kOffWhite, fontSize: 13)),
          backgroundColor: kDarkGrey, // Removed .withOpacity(0.8)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: kPrimaryMaroon, width: 1.5),
          ),
        ),
      );
    }
  }


  Widget _buildRouteSuggestionCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kDarkGrey,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: kPrimaryMaroon, width: 1.5),
          boxShadow: const [ // Made const since color is now opaque
            BoxShadow(
              color: kPrimaryMaroon, // Removed .withOpacity(0.3)
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/topanga_canyon_malibu.jpg', // Specific image for this route
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Topanga Canyon to Malibu',
                    style: TextStyle(color: kOffWhite, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.directions_bike, color: kAccentGold, size: 16),
                      const SizedBox(width: 5),
                      const Text(
                        'Easy',
                        style: TextStyle(color: Colors.greenAccent, fontSize: 12),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '20.52 mi · 1,539 ft (1h 22m)',
                        style: TextStyle(color: kOffWhite, fontSize: 12), // Removed .withOpacity(0.7)
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Calabasas, California, USA',
                    style: TextStyle(color: kOffWhite, fontSize: 11), // Removed .withOpacity(0.6)
                  ),
                  const Text(
                    'From your location',
                    style: TextStyle(color: kAccentGold, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: kOffWhite, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String unit, IconData icon) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kDarkGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kAccentGold, width: 1), // Removed .withOpacity(0.5)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: kPrimaryMaroon, size: 28),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: kOffWhite,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: kAccentGold,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
