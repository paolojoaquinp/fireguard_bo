import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraHelper {
  static final CameraHelper _instance = CameraHelper._internal();
  CameraController? _controller;
  List<CameraDescription>? _cameras;

  factory CameraHelper() {
    return _instance;
  }

  CameraHelper._internal();

  Future<void> initialize() async {
    if (_cameras == null) {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _controller!.initialize();
      }
    }
  }

  Future<String?> takePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera not initialized');
    }

    try {
      // Tomar la foto
      final XFile photo = await _controller!.takePicture();

      // Obtener el directorio temporal
      final directory = await getTemporaryDirectory();
      final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = path.join(directory.path, fileName);

      // Copiar la foto al directorio temporal
      await photo.saveTo(savedPath);

      return savedPath;
    } catch (e) {
      print('Error taking photo: $e');
      return null;
    }
  }

  CameraController? get controller => _controller;

  void dispose() {
    _controller?.dispose();
    _controller = null;
    _cameras = null;
  }

  bool get isInitialized => 
    _controller != null && _controller!.value.isInitialized;
}