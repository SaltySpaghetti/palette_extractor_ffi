import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'bindings.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                File file = File(result.files.single.path!);
                final palette = extractPalette(
                  Language.cpp,
                  file.path,
                  10,
                  10,
                );
                print(palette);
              } else {
                // User canceled the picker
              }
            },
            child: const Text('Extract Palette'),
          ),
        ),
      ),
    );
  }
}
