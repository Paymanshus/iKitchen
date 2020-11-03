// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:tflite/tflite.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// import 'dart:async';
// import 'dart:io';

// void main() {
//   runApp(MyApp());
// }

// const String encoder = "Encoder";
// const String decoder = "Decoder";

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: TfLiteHome(),
//     );
//   }
// }

// class TfLiteHome extends StatefulWidget {
//   // TfLiteHome({Key key}) : super(key: key);

//   @override
//   _TfLiteHomeState createState() => _TfLiteHomeState();
// }

// class _TfLiteHomeState extends State<TfLiteHome> {
//   String _model = encoder;
//   // String _model = decoder;

//   PickedFile _image;

//   double _imageWidth;
//   double _imageHeight;
//   bool _busy = false;

//   List<Widget> _recognitions;

//   @override
//   void initState() {
//     super.initState();
//     _busy = true;

//     loadModel().then((val) {
//       setState(() {
//         _busy = false;
//       });
//     });
//   }

//   loadModel() async {
//     Tflite.close();
//     try {
//       String res;
//       if (_model == encoder) {
//         res = await Tflite.loadModel(model: "assets/tflite/enc_model.tflite");
//       } else {
//         res = await Tflite.loadModel(model: "assets/tflite/dec_model.tflite");
//       }
//       print(res);
//     } on PlatformException {
//       print("Failed to load model");
//     }
//   }

//   selectFromImagePicker() async {
//     final image = await ImagePicker().getImage(source: ImageSource.gallery);
//     if (image == null) return;
//     setState(() {
//       _busy = true;
//     });
//     predictImage(image);
//   }

//   predictImage(PickedFile image) async {
//     if (image == null) return;

//     if (_model == encoder) {
//       await encode(image);
//     } else {
//       // _model == decoder
//       await decode(image);
//     }

//     FileImage(File(image.path))
//         .resolve(ImageConfiguration())
//         .addListener((ImageStreamListener((ImageInfo info, bool _) {
//           setState(() {
//             _imageWidth = info.image.width.toDouble();
//             _imageHeight = info.image.height.toDouble();
//           });
//         })));

//     setState(() {
//       _image = image;
//       _busy = false;
//     });
//   }

//   encode(PickedFile image) async {
//     final recognition = await Tflite.detectObjectOnImage(
//         path: image.path,
//         model: encoder,
//         threshold: 0.3,
//         imageMean: 0.0,
//         imageStd: 255.0,
//         numResultsPerClass: 1);

//     setState(() {
//       _recognitions = _recognitions;
//     });
//   }

//   decode(PickedFile image) async {
//     final recognition = await Tflite.detectObjectOnImage(
//         path: image.path,
//         model: decoder,
//         threshold: 0.3,
//         imageMean: 0.0,
//         imageStd: 255.0,
//         numResultsPerClass: 1);

//     setState(() {
//       _recognitions = _recognitions;
//     });
//   }

//   List<Widget> rendereBoxes(Size screen) {
//     if (_recognitions == null) return [];
//     if (_imageWidth == null || _imageHeight == null) return [];

//     double factorX = screen.width;
//     double factorY = _imageHeight / _imageHeight * screen.width;

//     Color blue = Colors.blue;

//     return _recognitions.map((re) {
//       return Positioned(
//         left: re["rect"]["x"] * factorX,
//         top: re["rect"]["y"] * factorY,
//         width: re["rect"]["w"] * factorX,
//         height: re["rect"]["h"] * factorY,
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: blue,
//               width: 3,
//             ),
//           ),
//           child: Text(
//             "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}",
//             style: TextStyle(
//               background: Paint()..color = blue,
//               color: Colors.white,
//               fontSize: 15,
//             ),
//           ),
//         ),
//       );
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     List<Widget> stackChildren = [];

//     stackChildren.add(
//       Positioned(
//         top: 0.0,
//         left: 0.0,
//         width: size.width,
//         child: _image == null
//             ? Text("No Image Selected")
//             : Image.file(File(_image.path)),
//       ),
//     );

//     stackChildren.addAll(renderBoxes(size));

//     if (_busy) {
//       stackChildren.add(Center(
//         child: CircularProgressIndicator(),
//       ));
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("ImageReader"),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.image),
//         tooltip: "Image from gallery",
//         onPressed: selectFromImagePicker,
//       ),
//       body: Stack(
//         children: stackChildren,
//       ),
//     );
//   }
// }
