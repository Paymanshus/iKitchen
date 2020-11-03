import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:camera/camera.dart';
import 'package:image_reader/pages/ImageReviewPage.dart';
import 'package:image_reader/pages/TfLiteHomeCam.dart';
import 'package:image_reader/styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';

import 'package:image_reader/pages/SelectionPage.dart';
// import 'package:image_reader/pages/DeprTfliteHome.dart';

List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iKitchen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Open Sans',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SelectionPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CameraController controller;
  int currentCamera = 0;
  bool isProcessing = false;

  void initState() {
    // TODO: implement initState
    super.initState();
    loadCamera();
    initModel();
  }

  initModel() async {
    await Tflite.loadModel(
      model: "assets/tflite/model_unquant.tflite",
      labels: "assets/tflite/labels.txt",
    );
  }

  loadCamera() async {
    controller =
        CameraController(cameras[currentCamera], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() async {
    await Tflite.close();
    await controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      key: _scaffoldKey,
      // TODO: add Semantic, Stack Inkwell or other pressable covering entity on top of camera layout
      // https://stackoverflow.com/questions/50347942/flutter-camera-overlay
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: <Widget>[
          controller.value.isInitialized
              ? Transform.scale(
                  scale: controller.value.aspectRatio / deviceRatio,
                  child: Center(
                    child: AspectRatio(
                      child: CameraPreview(controller),
                      aspectRatio: controller.value.aspectRatio,
                    ),
                  ),
                )
              : Container(),
          // Bottom Container
          Positioned(
            bottom: 0,
            child: Container(
              height: size.height / 2,
              width: size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [gradientStart, gradientStop]),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0, right: 24.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 50,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0, right: 24.0),
              child: IconButton(
                icon: Icon(
                  Icons.loop,
                  size: 50,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (cameras.length > 1) {
                    currentCamera = (currentCamera + 1) % cameras.length;
                    loadCamera();
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
          width: 72.0,
          height: 72.0,
          child: FloatingActionButton(
            backgroundColor: Colors.white38,
            shape: CircleBorder(
              side: BorderSide(color: Colors.white, width: 2.5),
            ),
            elevation: 2.0,
            onPressed: isProcessing
                ? null
                : () {
                    setState(() {
                      isProcessing = true;
                    });
                    _takePicture().then((path) async {
                      List recs = await Tflite.runModelOnImage(
                        path: path,
                        numResults: 2,
                        threshold: 0.5,
                        imageMean: 127.5,
                        imageStd: 127.5,
                      );
                      // final List<String> classes = List.from(recs
                      //     .map((rec) => "${rec["label"]}_${rec["confidence"]}")
                      //     .toList());
                      // print(classes);
                      isProcessing = false;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageReviewPage(
                            imagePath: path,
                            recs: recs,
                          ),
                        ),
                      );
                    });
                  },
            // tooltip: 'Increment',
            // child: Icon(Icons.lens, color: Colors.white, size: 72),
          )),
    );
  }

  Future<String> _takePicture() async {
    final Directory extdir = await getApplicationDocumentsDirectory();
    final String dirPath = "${extdir.path}/pictures/iKitchen";
    await Directory(dirPath).create(recursive: true);
    String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = "$dirPath/${timestamp()}.jpg";

    if (controller.value.isTakingPicture) {
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      print("Error: ${e}");
    }
    @override
    void dispose() {
      Tflite.close();
      super.dispose();
    }
  }
}
