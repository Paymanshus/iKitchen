import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
import 'dart:io';

class DeprTfliteHome extends StatefulWidget {
  // DeprTfliteHome({Key key}) : super(key: key);

  @override
  _DeprTfliteHomeState createState() => _DeprTfliteHomeState();
}

class _DeprTfliteHomeState extends State<DeprTfliteHome> {
  PickedFile _image;

  double _imageWidth;
  double _imageHeight;
  bool _busy = false;

  List _outputs;

  List<Widget> _recognitions;

  @override
  void initState() {
    super.initState();
    _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }

  loadModel() async {
    Tflite.close();
    try {
      String res;
      res = await Tflite.loadModel(
          model: "assets/tflite/model_unquant.tfile",
          labels: "assets/tflite/labels.txt");
    } on PlatformException {
      print("Failed to load model");
    }
  }

  selectFromImagePicker() async {
    final image = await ImagePicker().getImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      _busy = true;
    });
    predictImage(image);
  }

  predictImage(PickedFile image) async {
    if (image == null) return;

    await modelPredict(image);

    FileImage(File(image.path))
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _imageWidth = info.image.width.toDouble();
            _imageHeight = info.image.height.toDouble();
          });
        })));

    setState(() {
      _image = image;
      _busy = false;
    });
  }

  modelPredict(PickedFile image) async {
    final recognition = await Tflite.detectObjectOnImage(
        path: image.path,
        threshold: 0.3,
        imageMean: 0.0,
        imageStd: 255.0,
        numResultsPerClass: 1);

    setState(() {
      _recognitions = _recognitions;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> stackChildren = [];

    stackChildren.add(
      Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        child: _image == null
            ? Text("No Image Selected")
            : Image.file(File(_image.path)),
      ),
    );

    if (_busy) {
      stackChildren.add(Center(
        child: CircularProgressIndicator(),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("ImageReader"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.image),
        tooltip: "Image from gallery",
        onPressed: selectFromImagePicker,
      ),
      body: Stack(
        children: stackChildren,
      ),
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
