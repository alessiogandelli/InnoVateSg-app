import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'explore_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  // Removed ChatPage from screens list
  final List<Widget> _screens = const [
    ExplorePage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.psychology, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: () {
              // Innovation tips feature
            },
          ),
        ],
      ),
      body: _screens.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: "Chat",
            barrierColor: Colors.black54,
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (ctx, anim1, anim2) => const SizedBox.shrink(),
            transitionBuilder: (ctx, anim1, anim2, child) {
              var curve = Curves.easeOutBack;
              var curvedAnimation = CurvedAnimation(
                parent: anim1,
                curve: curve,
              );
              
              return ScaleTransition(
                scale: Tween(begin: 0.0, end: 1.0).animate(curvedAnimation),
                alignment: const Alignment(0.9, 0.9),
                child: FadeTransition(
                  opacity: anim1,
                  child: Hero(
                    tag: 'chatHero',
                    child: Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      insetPadding: const EdgeInsets.all(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          height: MediaQuery.of(ctx).size.height * 0.8,
                          child: const ChatPage(),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        backgroundColor: const Color(0xFF2E8B57),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Growth',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF2E8B57),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
