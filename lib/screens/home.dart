import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  late File _image;
  final imagePicker = ImagePicker();
  List predictions = [
    {
      'confidence': '        ',
      'label': '         ',
    }
  ];

  _loadimage_gallery() async {
    var image = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) {
      return null;
    } else {
      setState(() {
        _image = File(image.path);
        _loading = false;
      });
    }
    detectMask(_image);
  }

  _loadimage_camera() async {
    var image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    } else {
      setState(() {
        _image = File(image.path);
        _loading = false;
      });
    }
    detectMask(_image);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model/model_unquant.tflite',
        labels: 'assets/model/labels.txt');
  }

  detectMask(File image) async {
    var prediction = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      predictions = prediction!;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Mask Detector",
          style: GoogleFonts.roboto(),
        ),
      ),
      body: Container(
        height: h,
        width: w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 160,
              width: 160,
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/mask.png',
              ),
            ),
            Container(
              child: Text(
                "ML CLassifier",
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 70,
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  _loadimage_camera();
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.teal),
                    ),
                  ),
                ),
                child: Text(
                  "Camera",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Container(
              width: double.infinity,
              height: 70,
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  _loadimage_gallery();
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.teal),
                    ),
                  ),
                ),
                child: Text(
                  "Gallery",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _loading == true
                ? Container()
                : Container(
                    child: Column(
                      children: [
                        Text(
                          predictions[0]['label'].toString().substring(2),
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: predictions[0]['label']
                                        .toString()
                                        .substring(2) ==
                                    'no mask'
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          height: 200,
                          width: 200,
                          child: Image.file(_image),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "Confidence = " +
                              (predictions[0]['confidence'] * 100)
                                  .toString()
                                  .substring(0, 5) +
                              '%',
                          style: GoogleFonts.roboto(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
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
