import 'package:flutter/material.dart';
import 'themes_page.dart';
import 'assignments_page.dart';
import 'backgroundremover_page.dart';
import 'profile_page.dart';
import 'login_page.dart';
//import 'camera_page.dart';
import 'assignment_details_page.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String currentAssignment = "Take a photo of something red!";
  String assignmentFrequency = "Weekly";
  String currentTheme = "Night"; // Huidig thema
  String openAssignment = "03. The Moon"; // Open opdracht

  final List<String> friends = ["Alice", "Bob", "Charlie", "David", "Eve", "Frank"];
  final List<bool> onlineStatus = [true, false, true, false, true, false]; // Online status
  int currentFriendIndex = 0;

  void _nextFriends() {
    setState(() {
      currentFriendIndex = (currentFriendIndex + 3) % friends.length;
    });
  }

  void _previousFriends() {
    setState(() {
      currentFriendIndex = (currentFriendIndex - 3) % friends.length;
      if (currentFriendIndex < 0) {
        currentFriendIndex += friends.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.green],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Themes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ThemesPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Assignments'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AssignmentsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('API'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OtherPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.greenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Open assignments section
                const Text(
                  'Open assignment(s):',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Divider(color: Colors.white, thickness: 1), // White line after Open assignment section
                const SizedBox(height: 8),

                // Container voor het thema en de open opdracht
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Thema naam en open opdracht
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentTheme, // Naam van het thema
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              openAssignment, // Open opdracht
                              style: const TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),

                        // Camera icoon naast de tekst
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AssignmentDetailsPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Friends section
                const Text(
                  'Your friends:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Divider(color: Colors.white, thickness: 1), // White line after Open assignment section
                
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: _previousFriends,
                    ),
                    ...List.generate(
                      3,
                      (index) {
                        int friendIndex =
                            (currentFriendIndex + index) % friends.length;
                        return Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.lightBlue[100], 
                                  child: Text(
                                    friends[friendIndex][0],
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 8,
                                  backgroundColor: onlineStatus[friendIndex]
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ],
                            ),
                            Text(
                              friends[friendIndex],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward, color: Colors.white),
                      onPressed: _nextFriends,
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Leaderboard section
                const Text(
                  'Leaderboard:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Divider(color: Colors.white, thickness: 1), // White line after Open assignment section
                
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.lightBlue[100], 
                          child: Text(friends[index][0]),
                        ),
                        title: Text(friends[index]),
                        subtitle: Text('Points: ${(100 - index * 10).toString()}'),
                        trailing: Icon(
                          index == 0 ? Icons.star : Icons.star_border,
                          color: index == 0 ? Colors.amber : Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}