import 'package:flutter/material.dart';
import 'home_page.dart';

class ThemesPage extends StatefulWidget {
  const ThemesPage({super.key});

  @override
  State<ThemesPage> createState() => _ThemesPageState();
}

class _ThemesPageState extends State<ThemesPage> {
  final themeImages = [
    'assets/images/thema1.jpg',
    'assets/images/thema2.jpg',
    'assets/images/thema3.jpg',
    'assets/images/thema4.jpg',
    'assets/images/thema5.jpg',
    'assets/images/thema6.jpg',
    'assets/images/thema7.jpg', 
    'assets/images/thema8.jpg', 
  ];

  final themeNames = [
    'Night',
    'Underwater',
    'Black and White',
    'Exposure',
    'Nature',
    'Street',
    'Landscape',  
    'Experimental',  
  ];

  final themeDescriptions = {
    'Night': 'A tranquil theme featuring dark blues and blacks, evoking the peace of a quiet night.',
    'Underwater': 'A vibrant underwater theme filled with blues, greens, and aquatic elements.',
    'Black and White': 'A classic and minimalist theme focusing on high contrast and simplicity.',
    'Exposure': 'A theme emphasizing bright, vivid lighting and contrast, creating a dynamic atmosphere.',
    'Nature': 'A refreshing theme inspired by the outdoors, with natural greens and earthy tones.',
    'Street': 'A modern, urban theme with street art and bold colors reflecting city life.',
    'Landscape': 'A peaceful landscape theme capturing wide-open spaces and scenic views, perfect for nature lovers.',
    'Experimental': 'An experimental theme with abstract patterns and unique color schemes, offering a fresh perspective.',
  };

  final List<String> selectedThemes = [];

  void _toggleSelection(String theme) {
    setState(() {
      if (selectedThemes.contains(theme)) {
        selectedThemes.remove(theme); // Deselect
      } else {
        selectedThemes.add(theme); // Select
      }
    });
  }

  void _showThemeDetails(String theme) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Theme details'),
          content: Text(themeDescriptions[theme]!),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _saveSelection() {
    if (selectedThemes.isEmpty) {
      // Als er geen thema's geselecteerd zijn, toon een waarschuwing
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No selection'),
            content: const Text('Please select at least one theme before saving.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Sluit de dialoog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Als er thema's geselecteerd zijn, toon de geselecteerde thema's en ga naar de homepage
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Selected themes'),
            content: Text('You selected: ${selectedThemes.join(', ')}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Sluit de dialoog
                  // Navigeer naar de homepage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Themes',
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select a theme',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                    ),
                  ),
                  Text(
                    'Choose a theme that suits your style. Tap on any theme to see more details and select it.', 
                    style: TextStyle(
                      fontSize: 16,  // Smaller font for the description
                      fontWeight: FontWeight.normal,
                      color: Colors.white,  
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Divider(color: Colors.white, thickness: 1.0), // White line under the text
            ),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns (larger images)
                  crossAxisSpacing: 12.0, // Space between columns
                  mainAxisSpacing: 12.0, // Space between rows
                ),
                itemCount: themeImages.length,
                itemBuilder: (context, index) {
                  final theme = themeNames[index];
                  final image = themeImages[index];
                  final isSelected = selectedThemes.contains(theme);

                  return GestureDetector(
                    onTap: () => _toggleSelection(theme),
                    child: Stack(
                      children: [
                        // Theme image
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(color: Colors.green, width: 4)
                                : null,
                            image: DecorationImage(
                              image: AssetImage(image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Info button
                        Positioned(
                          top: 8,
                          right: 8,
                          child: InkWell(
                            onTap: () => _showThemeDetails(theme),
                            child: const Icon(
                              Icons.info,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        // Selection overlay
                        if (isSelected)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

       Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Divider(color: Colors.white, thickness: 1.0), // White line under the text
            ),

                  Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _saveSelection,
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue, width: 2), // Blauwe rand
                  backgroundColor: Colors.white, // De achtergrondkleur van de knop
                ),
                child: const Text(
                  'Save selection',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
