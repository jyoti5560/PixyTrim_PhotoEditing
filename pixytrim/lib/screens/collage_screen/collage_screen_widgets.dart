import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:pixytrim/models/collage_screen_model/single_image_file_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixytrim/controller/collage_screen_conroller/collage_screen_controller.dart';
import 'click_functions.dart';

final collageScreenController = Get.find<CollageScreenController>();

BoxDecoration collageMainImageBoxDecoration() {
  return BoxDecoration(
    color: collageScreenController
        .borderColor[collageScreenController.activeColor.value],
    image: collageScreenController.isActiveWallpaper.value ?
    DecorationImage(
      image: AssetImage("${collageScreenController.wallpapers[collageScreenController.activeWallpaper.value]}"),
      fit: BoxFit.fill,
    ) : null,
  );
}

class SingleImageShowModule extends StatefulWidget {
  int index;
  int? flex;

  SingleImageShowModule({
    required this.index,
    this.flex,
  });

  @override
  _SingleImageShowModuleState createState() => _SingleImageShowModuleState();
}
class _SingleImageShowModuleState extends State<SingleImageShowModule> {
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: widget.flex ?? 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () => onTapModule(index: widget.index),
              child: Obx(
                ()=> Padding(
                  padding: EdgeInsets.all(collageScreenController.borderWidthValue.value),
                  child: Container(
                    height: Get.height,
                    width: double.infinity,
                    child: Obx(
                          ()=> ClipRRect(
                        borderRadius: BorderRadius.circular(
                            collageScreenController.borderRadiusValue.value),
                            child: PhotoView(
                        enableRotation: true,
                        enablePanAlways: true,
                        imageProvider: FileImage(
                          File(
                            '${collageScreenController.imageFileList[widget.index].file.path}',
                          ),
                        ),
                        customSize: Size.fromRadius(320),
                      ),
                    ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: collageScreenController.imageFileList[widget.index].isVisible,
              child: Container(
                color: Colors.black45,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close_rounded, size: 30),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          collageScreenController.imageFileList[widget.index].isVisible
                          = !collageScreenController.imageFileList[widget.index].isVisible;
                        });
                      },
                    ),

                    IconButton(
                      icon: Icon(Icons.image, size: 30),
                      color: Colors.white,
                      onPressed: () async {
                        final image = await imagePicker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          collageScreenController.imageFileList.removeAt(widget.index);
                          collageScreenController.imageFileList.insert(widget.index, ImageFileItem(file: image));
                        }
                        setState(() {
                          collageScreenController.imageFileList[widget.index].isVisible
                          = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
    );
  }
}
