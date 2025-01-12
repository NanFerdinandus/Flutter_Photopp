import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({super.key});

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  File? _image;
  Uint8List? _processedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _removeBackground(_image!);
    }
  }

  Future<void> _removeBackground(File imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.remove.bg/v1.0/removebg'),
    );

    request.headers['X-Api-Key'] = 'zrCAK4uezPyZx8ZuhyvjJSkP';
    request.files.add(
      await http.MultipartFile.fromPath('image_file', imageFile.path),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final bytes = await response.stream.toBytes();
      if (mounted) {
        setState(() {
          _processedImage = bytes;
        });
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
    }
  }

  Future<void> _saveImage() async {
    if (_processedImage != null) {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/processed_image.png';
      final file = File(filePath);
      await file.writeAsBytes(_processedImage!);

      final result = await ImageGallerySaver.saveFile(file.path);

      if (!mounted) return;
      if (result['isSuccess'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save image!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API'),
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
                'Select a picture to edit:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Divider(color: Colors.white, thickness: 1, indent: 16, endIndent: 16),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Choose a picture',
                  style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: _image == null
                  ? const Text('Please select a picture', style: TextStyle(color: Colors.white, fontSize: 18))
                  : SizedBox(
                      width: 300,  // Set width for the image
                      child: Image.file(_image!),
                    ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white, thickness: 1, indent: 16, endIndent: 16),
            const SizedBox(height: 20),
            Center(
              child: _processedImage == null
                  ? const Text('No edited picture available', style: TextStyle(color: Colors.white, fontSize: 18))
                  : SizedBox(
                      width: 300,  // Set width for the processed image
                      child: Image.memory(_processedImage!),
                    ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save edited picture',
                  style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
