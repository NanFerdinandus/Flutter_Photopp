import 'package:flutter/material.dart';
import 'assignment_details_page.dart'; // Ensure this page exists

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AssignmentsPageState createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  // Initializing slider value to 0 (for 'Daily')
  double _sliderValue = 0;

  // List of frequencies corresponding to slider values
  final List<String> _frequencies = ['Daily', 'Weekly', 'Monthly'];

  // Method to get the selected frequency from slider value
  String get selectedFrequency {
    return _frequencies[_sliderValue.toInt()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
              child: Text(
                'Upcoming assignment:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Divider(color: Colors.white, thickness: 1, indent: 16, endIndent: 16),
            // Assignment Card
            Card(
              margin: const EdgeInsets.all(16.0),
              color: Colors.white.withOpacity(0.9),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: const Text(
                  'Night - Assignment 03: The Moon',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Explore the beauty of the moon and show your creativity!',
                  style: TextStyle(color: Colors.black),
                ),
                trailing: const Icon(
                  Icons.arrow_forward,
                  color: Colors.blue,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AssignmentDetailsPage(),
                    ),
                  );
                },
              ),
            ),
            // Frequency Selector Section (Slider)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose frequency:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Divider(color: Colors.white, thickness: 1),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          // Slider to select frequency
                          Slider(
                            value: _sliderValue,
                            min: 0,
                            max: 2,
                            divisions: 2,
                            label: _frequencies[_sliderValue.toInt()],
                            onChanged: (double value) {
                              setState(() {
                                _sliderValue = value;
                              });
                            },
                            activeColor: Colors.blue,
                            inactiveColor: Colors.blue.withOpacity(0.3),
                          ),
                          // Text to display the selected frequency
                          Text(
                            'Selected Frequency: ${_frequencies[_sliderValue.toInt()]}',
                            style: const TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          // Button to show the selected frequency in a Snackbar
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selected Frequency: $selectedFrequency'),
                                ),
                              );
                            },
                            // ignore: sort_child_properties_last
                            child: const Text(
                              'Confirm Frequency',
                              style: TextStyle(color: Colors.blue),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
