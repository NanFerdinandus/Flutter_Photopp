import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart'; 

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  String? _errorMessage;
  String? _capturedImagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Verkrijg beschikbare camera's
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw CameraException('NoAvailableCamera', 'Er zijn geen camera\'s beschikbaar');
      }

      final firstCamera = cameras.first;

      // Maak CameraController aan
      _controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      // Initialiseer camera
      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;

      setState(() {
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Fout tijdens initialisatie: $e';
      });
    }
  }

  Future<void> _capturePhoto() async {
    try {
      // Zorg ervoor dat de camera is geïnitialiseerd
      await _initializeControllerFuture;

      // Maak een foto
      final image = await _controller!.takePicture();

      // Verkrijg het pad naar de documenten-directory
      final Directory appDir = await getApplicationDocumentsDirectory();

      // Maak een nieuwe map aan voor afbeeldingen als deze nog niet bestaat
      final Directory imagesDir = Directory('${appDir.path}/images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      // Verplaats de foto naar de images map
      final String newPath = '${imagesDir.path}/${image.name}';
      await File(image.path).copy(newPath);

      setState(() {
        _capturedImagePath = newPath; // Bewaar het pad van de gemaakte foto
      });

      // Toon een bevestigingsbericht
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Foto opgeslagen: $newPath')),
      );
    } catch (e) {
      debugPrint('Fout tijdens het maken van een foto: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _initializeCamera,
                    child: const Text('Probeer Opnieuw'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(_controller!);
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Fout tijdens laden: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                if (_capturedImagePath != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Gemaakte foto:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Image.file(
                          File(_capturedImagePath!),
                          height: 150,
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _capturePhoto,
                    child: const Text('Maak Foto'),
                  ),
                ),
              ],
            ),
    );
  }
}