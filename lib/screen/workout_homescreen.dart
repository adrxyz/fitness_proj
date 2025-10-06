import 'package:flutter/material.dart';
import 'package:fitness_proj/widgets/color_constant.dart';
import 'map_screen.dart';
import 'workout_screen.dart';
import 'profile_screen.dart';
// 1. IMPORT THE EXTERNAL DATA FILE
import 'package:fitness_proj/story_feed/feed.dart'; 


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; 
  late List<Map<String, dynamic>> _feed;
  late final List<Widget> _widgetOptions;
  
  // NEW STATE VARIABLE: Tracks the currently selected filter chip
  String? _selectedFilterChip;

  // Placeholder data for Content Creators to display dynamically
  final List<Map<String, dynamic>> _featuredCreators = [
    {'username': 'Iron_Aura', 'specialty': 'Powerlifting', 'followers': '1.2M', 'avatar': 'assets/creator_1.jpg'},
    {'username': 'Swift_Shadow', 'specialty': 'Running & HIIT', 'followers': '850K', 'avatar': 'assets/creator_2.jpg'},
    {'username': 'Zenith_Flow', 'specialty': 'Yoga & Mobility', 'followers': '420K', 'avatar': 'assets/creator_3.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the mutable local list from the imported data
    _feed = List<Map<String, dynamic>>.from(storyFeedData); 

    // The HomeScreen widget itself (the feed) is the first screen.
    _widgetOptions = <Widget>[
      _buildHomeContent(),
      const MapScreen(), // Index 1
      const WorkoutScreen(), // Index 2
      const ProfileScreen(), // Index 3
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Clear filter when navigating away and back to home
      if (index != 0) {
        _selectedFilterChip = null;
      }
    });
  }

  void _toggleLike(int index) {
    setState(() {
      _feed[index]['isLiked'] = !_feed[index]['isLiked'];
      if (_feed[index]['isLiked']) {
        _feed[index]['likes']++;
      } else {
        _feed[index]['likes']--;
      }
    });
  }

  void _showCommentsBottomSheet(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.transparent, 
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7, 
            decoration: BoxDecoration(
              color: kDarkGrey, 
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              border: Border.all(color: kAccentGold, width: 2), 
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Comments on ${_feed[index]['username']}\'s post',
                    style: TextStyle(
                      color: kAccentGold,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: [
                      _buildSingleComment('Inferno_Rider', 'Absolutely crushing it! 🔥', '2h ago'),
                      _buildSingleComment('Beast_Mode_Engaged', 'That form is flawless!', '4h ago'),
                      _buildSingleComment('StrengthSeeker', 'Inspired by your dedication!', '1d ago'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    style: TextStyle(color: kOffWhite),
                    decoration: InputDecoration(
                      // Opacity removed
                      hintText: 'Add your fierce comment...',
                      hintStyle: TextStyle(color: kOffWhite), 
                      filled: true,
                      fillColor: kNearBlack, 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(color: kAccentGold, width: 1.5),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send, color: kAccentGold),
                        onPressed: () {
                          print('Comment submitted!');
                          Navigator.pop(context); 
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSingleComment(String username, String comment, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: kPrimaryMaroon,
            radius: 15,
            child: Text(username[0], style: TextStyle(color: kAccentGold, fontSize: 12)),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      username,
                      style: TextStyle(fontWeight: FontWeight.bold, color: kOffWhite),
                    ),
                    SizedBox(width: 8),
                    Text(
                      time,
                      // Opacity removed
                      style: TextStyle(color: kOffWhite, fontSize: 11),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  comment,
                  // Opacity removed
                  style: TextStyle(color: kOffWhite),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sharePost(int index) {
    print('Sharing post: ${_feed[index]['story']}');
  }

  void _createNewPost() {
    print('Opening new post creation interface');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: kDarkGrey,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            border: Border.all(color: kAccentGold, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Forge New Legend',
                    style: TextStyle(
                      color: kAccentGold,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          maxLines: 5,
                          style: TextStyle(color: kOffWhite),
                          decoration: InputDecoration(
                            // Opacity removed
                            hintText: 'What epic feat have you accomplished?',
                            hintStyle: TextStyle(color: kOffWhite),
                            filled: true,
                            fillColor: kNearBlack,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: kAccentGold, width: 1.5),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            print('Add media');
                          },
                          icon: Icon(Icons.camera_alt, color: kNearBlack),
                          label: Text('Add Media', style: TextStyle(color: kNearBlack)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentGold,
                            minimumSize: Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('New post created!');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Your legend has been forged!'),
                        backgroundColor: kAccentGold,
                      ),
                    );
                    Navigator.pop(context); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryMaroon,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'POST TO THE GAUNTLET',
                    style: TextStyle(color: kOffWhite, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNearBlack, 
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        title: Text(
          'THE GAUNTLET',
          style: TextStyle(
            color: kAccentGold,
            fontWeight: FontWeight.w900,
            fontSize: 24,
            letterSpacing: 3,
            shadows: [
              Shadow(
                blurRadius: 5.0,
                // Opacity removed
                color: kPrimaryMaroon, 
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: kNearBlack, 
        elevation: 0,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewPost,
        backgroundColor: kPrimaryMaroon, 
        child: Icon(Icons.add, color: kAccentGold, size: 30),
        shape: const CircleBorder(), 
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: <Widget>[
        // 1. Search Bar and Filter
        _buildSearchBarAndFilter(),

        // 2. Dynamic Content Area (Shows filter result or recommendation)
        if (_selectedFilterChip != null) 
          _buildDynamicContent(),
          _buildRecommendationCard(),

        // 3. Fierce Story Feed (Likes/Comments)
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 10),
            itemCount: _feed.length,
            itemBuilder: (context, index) {
              return _buildStoryPost(index, _feed[index]); 
            },
          ),
        ),
      ],
    );
  }

  // --- NEW DYNAMIC CONTENT WIDGET (Shows motivational creators) ---
  Widget _buildDynamicContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: kDarkGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kPrimaryMaroon, width: 1.5),
          boxShadow: [
            BoxShadow(
              // Opacity removed
              color: kPrimaryMaroon,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MOTIVATION: Featured ${_selectedFilterChip}',
              style: TextStyle(
                color: kAccentGold,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 120, // Fixed height for the horizontal list
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _featuredCreators.length,
                itemBuilder: (context, index) {
                  final creator = _featuredCreators[index];
                  return _buildCreatorCard(creator);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // NEW CREATOR CARD WIDGET
  Widget _buildCreatorCard(Map<String, dynamic> creator) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: kPrimaryMaroon,
            // NOTE: Replace AssetImage with NetworkImage or ensure your assets paths are correct
            backgroundImage: AssetImage(creator['avatar']!),
          ),
          SizedBox(height: 8),
          Text(
            creator['username']!,
            style: TextStyle(color: kOffWhite, fontWeight: FontWeight.bold, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            creator['specialty']!,
            // Opacity removed
            style: TextStyle(color: kOffWhite, fontSize: 10),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // --- MODIFIED _buildFilterChip (Now Clickable and Toggles State) ---

  Widget _buildSearchBarAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search the Shadows (e.g., Yoga, HIIT)',
              // Opacity removed
              hintStyle: TextStyle(color: kOffWhite),
              prefixIcon: Icon(Icons.search, color: kAccentGold),
              filled: true,
              fillColor: kDarkGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0),
            ),
            style: TextStyle(color: kOffWhite),
            onSubmitted: (query) {
              print("Searching for: $query");
            },
          ),
          SizedBox(height: 8),

          // Horizontal Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Muscle Group', Icons.fitness_center),
                _buildFilterChip('Duration', Icons.timer),
                _buildFilterChip('Difficulty', Icons.local_fire_department),
                _buildFilterChip('Equipment', Icons.hardware),
                // Add an option to clear the filter
                if (_selectedFilterChip != null)
                  _buildFilterChip('Clear Filter', Icons.close),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    final bool isSelected = _selectedFilterChip == label;
    final bool isClearChip = label == 'Clear Filter';

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip( // Use ActionChip for clickable behavior
        avatar: Icon(
          icon, 
          color: isClearChip ? Colors.white : (isSelected ? kNearBlack : kAccentGold), 
          size: 18
        ),
        label: Text(
          label, 
          style: TextStyle(
            color: isClearChip ? Colors.white : (isSelected ? kNearBlack : kOffWhite), 
            fontSize: 13,
            fontWeight: isSelected || isClearChip ? FontWeight.bold : FontWeight.normal,
          )
        ),
        // Opacity removed
        backgroundColor: isClearChip 
            ? kPrimaryMaroon 
            : (isSelected ? kAccentGold : kDarkGrey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? kAccentGold : kPrimaryMaroon, 
            width: 1.5
          ),
        ),
        onPressed: () {
          setState(() {
            if (isClearChip || isSelected) {
              _selectedFilterChip = null; // Deselect or clear
            } else {
              _selectedFilterChip = label; // Select new chip
            }
          });
        },
      ),
    );
  }

  Widget _buildRecommendationCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: kDarkGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kAccentGold, width: 1.5),
          boxShadow: [
            BoxShadow(
              // Opacity removed
              color: kPrimaryMaroon,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.bolt, color: kAccentGold, size: 30),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'REVELATION: RECOMMENDED',
                    style: TextStyle(
                      color: kPrimaryMaroon,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Based on your last **HIIT** session, try the **"Shadow Sprints"** workout.',
                    // Opacity removed
                    style: TextStyle(color: kOffWhite),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: kAccentGold, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryPost(int index, Map<String, dynamic> post) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: kDarkGrey,
      elevation: 5,
      shape: RoundedRectangleBorder(
        // Opacity removed
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: kPrimaryMaroon, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // User Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: kPrimaryMaroon,
                  radius: 18,
                  backgroundImage: post['avatar_url'] != null
                      ? AssetImage(post['avatar_url']!) as ImageProvider<Object>?
                      : null,
                  child: post['avatar_url'] == null
                      ? Text(post['username'][0], style: TextStyle(color: kAccentGold, fontWeight: FontWeight.bold))
                      : null,
                ),
                SizedBox(width: 10),
                Text(
                  post['username']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kAccentGold,
                  ),
                ),
                Spacer(),
                // Opacity removed
                Icon(Icons.more_vert, color: kOffWhite),
              ],
            ),
            SizedBox(height: 10),

            // The Fierce Story Text
            Text(
              post['story']!,
              style: TextStyle(color: kOffWhite, fontSize: 16),
            ),
            SizedBox(height: 10),

            // Image of the post (if available)
            if (post['image_url'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  post['image_url']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200, 
                  errorBuilder: (context, error, stackTrace) {
                    print('Asset failed to load: ${post['image_url']} - $error');
                    return Container(
                      height: 200,
                      color: kNearBlack,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, color: kPrimaryMaroon, size: 40),
                            SizedBox(height: 8),
                            Text(
                              'Image Unavailable: No Legend Found',
                              // Opacity removed
                              style: TextStyle(color: kOffWhite, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 10),

            // Likes and Comments Bar
            // Opacity removed
            Divider(color: kPrimaryMaroon),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInteractionButton(
                  icon: post['isLiked'] ? Icons.favorite : Icons.favorite_border,
                  count: post['likes']!,
                  label: 'Likes',
                  color: post['isLiked'] ? Colors.redAccent : kAccentGold, 
                  onTap: () => _toggleLike(index),
                ),
                _buildInteractionButton(
                  icon: Icons.comment_outlined,
                  count: post['comments']!,
                  label: 'Comments',
                  onTap: () => _showCommentsBottomSheet(index), 
                ),
                _buildInteractionButton(
                  icon: Icons.share,
                  count: 0,
                  label: 'Share',
                  onTap: () => _sharePost(index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Updated _buildInteractionButton to be clickable
  Widget _buildInteractionButton({
    required IconData icon,
    required int count,
    required String label,
    Color color = kAccentGold, 
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 5),
            Text(
              count > 0 ? count.toString() : label,
              // Opacity removed
              style: TextStyle(color: kOffWhite, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Redesigned Bottom Navigation Bar with CircularNotchedRectangle
  Widget _buildBottomNavigationBar() {
    // Opacity removed
    final Color bottomBarColor = kNearBlack;

    return Container(
      // The outer container for the top border/shadow effect
      decoration: BoxDecoration(
        color: bottomBarColor, 
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)), 
        border: Border(
          // Opacity removed
          top: BorderSide(color: kPrimaryMaroon, width: 1.5), 
        ),
        boxShadow: [
          BoxShadow(
            // Opacity removed
            color: kPrimaryMaroon,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)), 
        child: BottomAppBar(
          color: bottomBarColor, 
          height: 70.0, 
          notchMargin: 8.0, 
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_filled, 'HOME'),
              _buildNavItem(1, Icons.map_rounded, 'MAP'),
              _buildNavItem(2, Icons.fitness_center_rounded, 'WORKOUT'),
              _buildNavItem(3, Icons.person_rounded, 'PROFILE'), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Container(
          height: 60, // Give the nav item a fixed height for consistent tap area
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                // Opacity removed
                color: isSelected ? kAccentGold : kOffWhite,
                size: isSelected ? 30 : 26,
              ),
              Text(
                label,
                style: TextStyle(
                  // Opacity removed
                  color: isSelected ? kAccentGold : kOffWhite,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
