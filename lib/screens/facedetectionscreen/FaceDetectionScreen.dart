// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, unused_local_variable, file_names, unnecessary_nullable_for_final_variable_declarations, unused_field, avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../screens.dart';

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({Key? key}) : super(key: key);

  @override
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  late CameraController? _cameraController;
  late FaceDetector _faceDetector;
  bool _isDetecting = false;
  bool _isCameraInitialized = false;
  bool _isCapturingPhoto = false;
  bool _isCameraActive = true;
  XFile? _imageFile; // Variable to store the captured image

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    // Evitar rotación de pantalla
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _initializeCamera() async {
    final permissionStatus = await Permission.camera.request();
    if (permissionStatus.isGranted) {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(frontCamera, ResolutionPreset.high,
          enableAudio: false);
      final camera = _cameraController!;
      final size = MediaQuery.of(context).size;
      await camera.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
        _faceDetector = GoogleMlKit.vision.faceDetector();
        camera.startImageStream((CameraImage image) {
          // Process camera image frames
          // ...
        });
      }
    } else {
      // Handle if permissions are denied
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Face Detection')),
      body: Stack(
        children: [
          _isCameraInitialized
              ? Stack(
                  children: [
                    CameraPreview(_cameraController!),
                    CustomPaint(
                      painter:
                          FaceOvalPainter(), // Dibuja el óvalo en el rostro
                      size: MediaQuery.of(context).size,
                    ),
                    ClipPath(
                      clipper: OvalClipper(), // Recorta el área fuera del óvalo
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 5.0,
                            sigmaY: 5.0), // Aplica un filtro de desenfoque
                        child: Container(
                          color: Colors.black
                              .withOpacity(0.4), // Color oscuro con opacidad
                        ),
                      ),
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: _isCameraActive ? _capturePhoto : null,
                backgroundColor: Colors.white,
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _capturePhoto() async {
    if (!_isDetecting) {
      _isDetecting = true;

      try {
        // Mostrar indicador de progreso
        setState(() {
          _isCapturingPhoto = true;
          _isCameraActive = false;
        });

        final XFile? imageFile = await _cameraController!.takePicture();

        if (imageFile != null) {
          _imageFile = imageFile; // Asignar el archivo de imagen a _imageFile
          final InputImage inputImage = InputImage.fromFilePath(imageFile.path);
          final List<Face> faces = await detectFacesInImage(inputImage);

          if (faces.isNotEmpty) {
            // Rostro detectado, procesa la imagen
            if (_isGoodLighting(faces)) {
              await _detectFacesAndUploadToFirebaseStorage(inputImage);
              _showAlert('Foto capturada exitosamente');

              // Esperar un breve tiempo antes de navegar
              await Future.delayed(const Duration(
                  seconds: 5)); // Cambia el tiempo según necesites

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateAccountScreen()),
              );
            } else {
              _showAlert(
                'La iluminación es insuficiente, intenta de nuevo',
                isError: true,
              );
            }
          } else {
            // No se detectaron rostros
            _showAlert('No se detectó ningún rostro', isError: true);
          }
        }
      } catch (e) {
        print('Error capturando la foto: $e');
      } finally {
        // Ocultar indicador de progreso después de la captura
        setState(() {
          _isCapturingPhoto = false;
          _isDetecting = false;
          _isCameraActive = true;
        });
      }
    }
  }

  bool _isGoodLighting(List<Face> faces) {
    const double brightnessThreshold = 0.6;

    if (faces.isNotEmpty) {
      double totalBrightness = 0;
      faces.forEach((face) {
        totalBrightness += face.headEulerAngleY ?? 0;
      });

      double avgBrightness = totalBrightness / faces.length;

      return avgBrightness > brightnessThreshold;
    }

    return false;
  }

  Future<void> _detectFacesAndUploadToFirebaseStorage(
      InputImage inputImage) async {
    try {
      final List<Face> faces = await detectFacesInImage(inputImage);

      if (faces.isNotEmpty) {
        print('Rostros detectados: ${faces.length}');
        // Implementa la lógica para procesar los rostros detectados aquí

        // Asegúrate de que _imageFile no sea nulo antes de subirlo
        if (_imageFile != null) {
          await uploadImageToFirebaseStorage(_imageFile!);
          // Muestra una alerta de éxito después de subir a Firebase
          //_showAlert('Imagen subida a Firebase Storage');
        } else {
          print('El archivo de imagen es nulo');
        }
      }
    } catch (error) {
      print('Error detectando rostros: $error');
    } finally {
      _isDetecting = false;
    }
  }

  Future<List<Face>> detectFacesInImage(InputImage inputImage) async {
    final List<Face> faces = await _faceDetector.processImage(inputImage);
    return faces;
  }

  Future<void> uploadImageToFirebaseStorage(XFile imageFile) async {
    final firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('images') // Change 'images' to your desired storage path
        .child(
            'face_image_${DateTime.now().millisecondsSinceEpoch}.jpg'); // Change the file name as needed

    final firebase_storage.UploadTask uploadTask = storageRef.putFile(
      File(imageFile.path),
      firebase_storage.SettableMetadata(contentType: 'image/jpeg'),
    );

    await uploadTask
        .whenComplete(() => print('Image uploaded to Firebase Storage'));
  }

  void _showAlert(String message, {bool isError = false}) {
    final contentType = isError ? ContentType.warning : ContentType.success;
    final snackBar = SnackBar(
      content: AwesomeSnackbarContent(
        title: isError ? 'Error' : 'Success',
        message: message,
        contentType: contentType,
        color: isError
            ? Colors.orange
            : null, // Establece el color naranja para errores
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class FaceOvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Aquí obtienes la información de los rostros detectados y ajustas el ovalo según la posición y tamaño del rostro
    // Usando la información de los rostros detectados (quizás desde la función detectFacesInImage()),
    // puedes obtener las posiciones y tamaños del rostro y dibujar un ovalo alrededor de él

    // Por ejemplo, aquí se dibuja un ovalo estático en el centro de la pantalla
    final ovalRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.width * 0.8, // Ancho del ovalo
      height: size.height * 0.6, // Alto del ovalo
    );

    final paint = Paint()
      ..color = Colors.white // Color del ovalo
      ..style = PaintingStyle
          .stroke // Puedes cambiar a PaintingStyle.fill si quieres rellenar el ovalo
      ..strokeWidth = 2.0; // Grosor del ovalo

    canvas.drawOval(ovalRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class OvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.width * 0.8, // Ancho del óvalo
      height: size.height * 0.6, // Alto del óvalo
    ));
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    return path..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
