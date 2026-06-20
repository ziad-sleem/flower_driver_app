import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

abstract class ImagePickerService {
  Future<String?> pickImage();
}

@LazySingleton(as: ImagePickerService)
class ImagePickerServiceImpl implements ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);

    return image?.path;
  }
}
