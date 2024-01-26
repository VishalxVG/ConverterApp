// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:pdf/widgets.dart' as pw;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imgaeFile;
  File? _pdfFile;
  File? _excelFile;

  // To Pick image from gallery and Convert to PDF
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

  // Convert to pdf
  Future<void> _convertToPdf() async {
    // Case where no image is selected
    if (_imgaeFile == null) {
      print("Imgae is not selected");
    }
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        final imageBytes = _imgaeFile!.readAsBytesSync();
        return pw.Center(
            child: pw.Image(
          pw.MemoryImage(imageBytes),
          width: 500,
          height: 500,
        ));
      },
    ));

    // Save the PDF as a List<int>
    final List<int> pdfBytes = await pdf.save();

    // Get the application documents directory
    final directory = await getApplicationDocumentsDirectory();

    // Save the PDF to a file in the documents directory
    final pdfFile = File('${directory.path}/converted_image.pdf');
    await pdfFile.writeAsBytes(pdfBytes);

    setState(() {
      _pdfFile = pdfFile;
    });
  }

  // Funtion to convert to excel
  Future<void> _convertToExel() async {
    // Handle if image is not selected
    if (_imgaeFile == null) {
      return;
    }
    final Uint8List imageBytes = await _imgaeFile!.readAsBytes();
    final Excel excel = Excel.createExcel();
    final Sheet sheetObject = excel['Sheet 1'];

    //TODO_Convert Image bytes to Excel format

    // Save the Excel as List<int>
    final List<int>? excelBytes = excel.encode();

    // Applicaiton documents directory
    final directory = await getApplicationDocumentsDirectory();

    // Save the Excel to a file in a documents directory
    final excelFile = File('${directory.path}/converted_image.xlsl');
    await excelFile.writeAsBytes(excelBytes!);

    setState(() {
      _excelFile = excelFile;
    });
  }

  // Funtion to share the PDF File

  Future<void> _sharePDF() async {
    // Handle if pdfFile is not selected
    if (_pdfFile == null) {
      print("Pdf is not selected");
    }

    // Share to WatsApp
    await Share.file(
      "Share via WatsApp",
      "converted_image.pdf",
      _pdfFile!.readAsBytesSync(),
      "application/pdf",
      text: "Check out this Pdf File",
    );
  }

  // Funtion to reset the image (If wrong Image picker)
  void _resetImage() {
    setState(() {
      _imgaeFile = null;
      _pdfFile = null;
      _excelFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Converter App",
        ),
        backgroundColor: const Color.fromARGB(255, 132, 110, 194),
        centerTitle: true,
      ),
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     _imgaeFile != null
      //         ? Image.file(_imgaeFile!)
      //         : const Text("No Image Selected"),
      //     const SizedBox(
      //       height: 20,
      //     ),
      //     ElevatedButton(
      //       onPressed: _pickImageAndConvertToPdf,
      //       child: const Text("Convert To Pdf"),
      //     ),
      //     const SizedBox(
      //       height: 10,
      //     ),
      //     ElevatedButton(
      //         onPressed: () {}, child: const Text("Convert to Excel")),
      //     ElevatedButton(
      //       onPressed: _sharePDF,
      //       child: const Text("Share To WatsApp"),
      //     ),
      //     const SizedBox(
      //       height: 20,
      //     ),
      //     ElevatedButton(
      //       onPressed: _resetImage,
      //       child: const Text("Chose another Image"),
      //     )
      //   ],
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Container(
                child: _imgaeFile != null
                    ? Image.file(_imgaeFile!)
                    : const Text(
                        "No Image Selected",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 116, 59, 126))),
                    onPressed: _pickImageAndConvertToPdf,
                    child: const Text("CONVERT TO PDF"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 116, 59, 126))),
                      onPressed: () {},
                      child: const Text("CONVERT TO EXCEL")),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 116, 59, 126))),
                    onPressed: _sharePDF,
                    child: const Text("SHARE TO WATSAPP"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 116, 59, 126))),
                    onPressed: _resetImage,
                    child: const Text("CHOSE ANOTHER IMAGE"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
