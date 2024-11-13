// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class AIPage extends StatefulWidget {
  @override
  _AIPageState createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  File? _image;
  String _analysisResult = '';
  bool _isAnalyzing = false;
  final ImagePicker _picker = ImagePicker();

  // Initialize Gemini AI
  // Replace 'YOUR_API_KEY' with your actual Gemini API key
  final model = GenerativeModel(
    model: 'gemini-pro-vision',
    apiKey: 'AIzaSyBC4RhEUPY3MSy8FkmTYKTtdcqtJvOvu-Y',
  );

  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _analysisResult = '';
      });
      _analyzeImage();
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      // Read image bytes
      final imageBytes = await _image!.readAsBytes();

      // Create content parts
      final contents = [
        TextPart(
            'Analyze this image and provide detailed information about what you see.'),
        DataPart('image/jpeg', imageBytes),
      ];

      // Generate content
      final response =
          await model.generateContent(contents as Iterable<Content>);

      setState(() {
        _analysisResult = response.text ?? 'No analysis available';
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _analysisResult = 'Error analyzing image: $e';
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Image Analysis'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_image != null)
              Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _getImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _getImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Choose from Gallery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_isAnalyzing)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
              ),
            if (_analysisResult.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _analysisResult,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
