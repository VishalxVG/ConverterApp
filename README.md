 # Image Converter App

This app allows users to convert images to PDF and Excel formats, and share the converted files via WhatsApp.

## Prerequisites

- Dart
- Flutter
- esys_flutter_share_plus
- image_picker
- excel
- pdf

## Implementation

### 1. Importing necessary libraries

```dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:pdf/widgets.dart' as pw;
```

### 2. Creating the main widget

```dart
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
```

### 3. Creating the state class

```dart
class _HomePageState extends State<HomePage> {
  File? _imgaeFile;
  File? _pdfFile;
  File? _excelFile;
```

### 4. Defining the functions

#### 4.1. `_pickImageAndConvertToPdf()`

This function picks an image from the gallery and converts it to PDF.

```dart
  Future<void> _pickImageAndConvertToPdf() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _imgaeFile = File(pickedFile.path);
      _pdfFile = null;
    }
    _convertToPdf();
    _convertToExel();
  }
```

#### 4.2. `_convertToPdf()`

This function converts the image to PDF.

```dart
  Future<void> _convertToPdf() async {
    // Case where no image is selected
    if (_imgaeFile == null) {
      print("Imgae is not selected");
    }
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        
