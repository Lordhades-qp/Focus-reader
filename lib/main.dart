import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:translator/translator.dart';
import 'dart:io';

void main() => runApp(FocusReaderApp());

class FocusReaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Reader',
      theme: ThemeData.dark(),
      home: ReaderHome(),
    );
  }
}

class ReaderHome extends StatefulWidget {
  @override
  _ReaderHomeState createState() => _ReaderHomeState();
}

class _ReaderHomeState extends State<ReaderHome> {
  FlutterTts flutterTts = FlutterTts();
  GoogleTranslator translator = GoogleTranslator();
  String fileText = "";
  String translatedText = "";
  String targetLang = "fr"; // langue de traduction (fr = français)

  Future<void> pickTranslateAndReadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = File(result.files.single.path!);
      final text = await file.readAsString();
      final translation = await translator.translate(text, to: targetLang);
      setState(() {
        fileText = text;
        translatedText = translation.text;
      });
      await flutterTts.speak(translatedText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Focus Reader")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickTranslateAndReadFile,
              child: Text("Choisir un fichier à traduire et lire"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(translatedText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
