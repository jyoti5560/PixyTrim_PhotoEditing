import 'package:image_picker/image_picker.dart';

class ImageFileItem {
  XFile file;
  bool isVisible = false;

  ImageFileItem({required this.file, this.isVisible = false});
}