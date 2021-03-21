import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File _image;
  List _output;
  final picker = ImagePicker();

  detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void initState() {
    print("akaash");
    super.initState();
    loadModel();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }


  pickImage(ImageSource source) async {

    var image = await picker.getImage(source: source);
    print(image.path);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0x004242),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 25),
              Text(
                "Cat-Dog Detector App",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: _loading
                    ? Container(
                  height: 400,
                        child: Image.asset(
                          "assets/cat_dog_icon.png",fit: BoxFit.scaleDown,

                        ),
                      )
                    : Container(
                        child: Column(
                          children: [
                            Container(
                              height: 250,
                              child: Image.file(_image),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            _output != null
                                ? Text(
                                    "Classification : ${_output[0]["label"]}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
                                  )
                                : Container(),
                            SizedBox(
                              height: 120,
                            )
                          ],
                        ),
                      ),
              ),
              GestureDetector(
                onTap: () => pickImage(ImageSource.camera),
                child: Container(
                  width: width - 200,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Capture a Photo",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => pickImage(ImageSource.gallery),
                child: Container(
                  width: width - 200,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Select a Photo",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
