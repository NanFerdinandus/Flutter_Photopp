import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:torch_light/torch_light.dart';
import 'package:sensors_plus/sensors_plus.dart'; 
import '../database/database_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String selectedTheme = 'Black and White';
  List<Map<String, dynamic>> profiles = [];
  int? selectedProfileId;
  String locationMessage = '';
  bool isTorchOn = false; // Houdt bij of de torch aan of uit is
  bool isShaking = false; // Houdt bij of er geschud wordt

  @override
  void initState() {
    super.initState();
    _loadProfiles();

    // Luister naar accelerometer gegevens voor schudbeweging
    _listenToShake();
  }

  void _listenToShake() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (!mounted) return; // Check if the widget is still mounted before calling setState()

      double shakeThreshold = 15;  // Drempel voor schudbeweging

      // Als de snelheid van de beweging boven de drempel komt, wordt het als een schudbeweging beschouwd
      if (event.x.abs() > shakeThreshold || event.y.abs() > shakeThreshold || event.z.abs() > shakeThreshold) {
        if (!isShaking) {
          setState(() {
            isShaking = true;
          });
          _showShakeDialog();  // Toon de pop-upmelding
        }
      } else {
        setState(() {
          isShaking = false;
        });
      }
    });
  }

  void _showShakeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hold your phone still'),
          content: const Text('You can\'t make good pictures with this hand.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _loadProfiles() async {
    final data = await DatabaseHelper.instance.readAllProfiles();
    setState(() {
      profiles = data;
    });
  }

  void _saveProfile() async {
    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
      _showErrorDialog('Please fill in all fields.');
      return;
    }

    final profile = {
      'name': nameController.text,
      'theme': selectedTheme,
      'description': descriptionController.text,
      'location': locationMessage,
    };

    if (selectedProfileId == null) {
      await DatabaseHelper.instance.createProfile(profile);
    } else {
      await DatabaseHelper.instance.updateProfile(selectedProfileId!, profile);
    }
    _clearFields();
    _loadProfiles();
  }

  void _deleteProfile(int id) async {
    await DatabaseHelper.instance.deleteProfile(id);
    _loadProfiles();
  }

  void _editProfile(Map<String, dynamic> profile) {
    setState(() {
      selectedProfileId = profile['id'];
      nameController.text = profile['name'];
      selectedTheme = profile['theme'];
      descriptionController.text = profile['description'];
    });
  }

  void _clearFields() {
    setState(() {
      nameController.clear();
      descriptionController.clear();
      selectedTheme = 'Black and White';
      selectedProfileId = null;
    });
  }

  void _getGpsLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        locationMessage = 'GPS turned off';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          locationMessage = 'Access denied';
        });
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      locationMessage = 'Lat: ${position.latitude}, Lon: ${position.longitude}';
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Functie om de torch in te schakelen
  Future<void> _toggleTorch() async {
    try {
      if (isTorchOn) {
        await TorchLight.disableTorch();
        setState(() {
          isTorchOn = false;
        });
      } else {
        await TorchLight.enableTorch();
        setState(() {
          isTorchOn = true;
        });
      }
    } on Exception catch (_) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.greenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manage assignments:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Divider(color: Colors.white, thickness: 1),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Assignment name',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choose a theme',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    value: selectedTheme,
                    dropdownColor: Colors.white,
                    items: ['Black and White', 'Night', 'Underwater', 'Exposure', 'Nature', 'Street', 'Landscape', 'Experimental']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedTheme = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Description of the assignment',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.blue),
                    foregroundColor: Colors.blue,
                  ),
                  child: const Text('Save'),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Saved assignments:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Divider(color: Colors.white, thickness: 1),
                const SizedBox(height: 16),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    final profile = profiles[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(profile['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${profile['theme']}'),
                            const SizedBox(height: 4),
                            Text(profile['description']),
                          ],
                        ),
                        onTap: () => _editProfile(profile),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editProfile(profile),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteProfile(profile['id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                             const SizedBox(height: 30),
                const Text(
                  'Mobile specific functions:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Divider(color: Colors.white, thickness: 1),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _getGpsLocation,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text('Get GPS location'),
                ),
                const SizedBox(height: 16),
                Text(locationMessage),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _toggleTorch,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: Text(isTorchOn ? 'Turn Torch Off' : 'Turn Torch On'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
