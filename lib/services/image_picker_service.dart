import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    return await _saveImage(pickedFile);
  }

  Future<String?> pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    return await _saveImage(pickedFile);
  }

  Future<String?> _saveImage(XFile? pickedFile) async {
    if (pickedFile == null) return null;
    final directory = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${directory.path}/place_images');
    if (!await imageDir.exists()) await imageDir.create();
    final fileName = '${const Uuid().v4()}.jpg';
    final savedPath = '${imageDir.path}/$fileName';
    final File savedImage = await File(pickedFile.path).copy(savedPath);
    return savedImage.path;
  }
}
