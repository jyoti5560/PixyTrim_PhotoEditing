import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/camera_screen_controller/camera_screen_controller.dart';
import 'package:pixytrim/screens/image_editor_screen/_paint_over_image.dart';

class ImageEditorScreen extends StatefulWidget {
  //const ImageEditorScreen({Key? key}) : super(key: key);
  File file;
  ImageEditorScreen({required this.file});

  @override
  _ImageEditorScreenState createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  final _imageKey = GlobalKey<ImagePainterState>();
  final GlobalKey repaintKey = GlobalKey();
  final csController = Get.find<CameraScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          MainBackgroundWidget(),

          Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Column(
              children: [
              SizedBox(
                height: 60,
              ),

                appBar(),

                SizedBox(height: 20,),

                Expanded(
                  child: ImagePainter.file(
                    widget.file,
                    repaintKey: repaintKey,
                    key: _imageKey,
                    scalable: false,
                    initialStrokeWidth: 2,
                    initialColor: Colors.green,
                    initialPaintMode: PaintMode.freeStyle,
                    // placeholderWidget: Container(
                    //   child: Text("jdjdh"),
                    // ),
                  ),
                ),

              ],
            ),
          )

        ],
      ),
    );
  }

  Widget appBar() {
    return Container(
      height: 50,
      width: Get.width,
      decoration: borderGradientDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: containerBackgroundGradient(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    //Get.back();
                    showAlertDialog();
                  },
                  child: Container(
                      child: Image.asset(Images.ic_left_arrow, scale: 2.5,)
                  ),
                ),
                Container(
                  child: Text(
                    "Image Edit",
                    style: TextStyle(
                        fontFamily: "",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () async{
                    renameAndSaveImage();
                    // await _capturePng();
                    Get.back();
                  },
                  child: Container(
                      child: Image.asset(Images.ic_downloading, scale: 2,)
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget imageEditingIcon(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2),
                height: 50,
                width: 50,
                margin: EdgeInsets.only(right: 8),
                decoration: borderGradientDecoration(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  //margin: EdgeInsets.only(left: 10, right: 10),

                  child: Center(
                      child: Image.asset(
                        Images.ic_edit,
                        scale: 2.5,
                      )),
                ),
              ),


              GestureDetector(
                onTap: (){
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(right: 8),
                  decoration: borderGradientDecoration(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    //margin: EdgeInsets.only(left: 10, right: 10),

                    child: Center(
                        child: Image.asset(
                          Images.ic_color_palate,
                          scale: 2.5,
                        )),
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.all(2),
                height: 50,
                width: 50,
                margin: EdgeInsets.only(right: 8),
                decoration: borderGradientDecoration(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  //margin: EdgeInsets.only(left: 10, right: 10),

                  child: Center(
                      child: Image.asset(
                        Images.ic_paint_brush,
                        scale: 2.5,
                      )),
                ),
              ),

              Container(
                padding: EdgeInsets.all(2),
                height: 50,
                width: 50,
                margin: EdgeInsets.only(right: 8),
                decoration: borderGradientDecoration(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  //margin: EdgeInsets.only(left: 10, right: 10),

                  child: Center(
                      child: Image.asset(
                        Images.ic_text,
                        scale: 2.5,
                      )),
                ),
              ),
            ],
          ),

          Row(
            children: [
              Center(
                  child: Icon(Icons.undo_outlined, size: 30,)),
              SizedBox(width: 10,),
              Center(
                  child: Icon(Icons.close, size: 30,)),
            ],
          )

        ],
      ),
    );
  }

  // Rename & Save Capture Image
  Future renameAndSaveImage() async {
    final image = await _imageKey.currentState!.exportImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/sample').create(recursive: true);
    final fullPath = '$directory/sample/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final imgFile = File('$fullPath');
    imgFile.writeAsBytesSync(image!);
    csController.addImageFromCameraList[csController.selectedIndex.value] = imgFile;
    await GallerySaver.saveImage(imgFile.path, albumName: "OTWPhotoEditingDemo");


  }

  // Future _capturePng() async {
  //   try {
  //     print('inside');
  //     DateTime time = DateTime.now();
  //     final imgName = "${time.day}_${time.month}_${time.year}_${time.hour}_${time.minute}_${time.second}";
  //     RenderRepaintBoundary boundary =
  //     repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //     print(boundary);
  //     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //     print("image:===$image");
  //     final directory = (await getApplicationDocumentsDirectory()).path;
  //     ByteData? byteData =
  //     await image.toByteData(format: ui.ImageByteFormat.png);
  //     print("byte data:===$byteData");
  //     Uint8List pngBytes = byteData!.buffer.asUint8List();
  //     File imgFile = new File('$directory/$imgName.png');
  //     await imgFile.writeAsBytes(pngBytes);
  //     setState(() {
  //       csController.addImageFromCameraList[csController.selectedImage.value] = imgFile;
  //     });
  //     //print("File path====:${blur!.path}");
  //     //collageScreenController.imageFileList = pngBytes;
  //     //bs64 = base64Encode(pngBytes);
  //     print("png Bytes:====$pngBytes");
  //     //print("bs64:====$bs64");
  //     //setState(() {});
  //     //await saveImage();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  showAlertDialog() {

    Widget cancelButton = TextButton(
      child: Text("Cancel", style: TextStyle(fontFamily: ""),),
      onPressed:  () {
        Get.back();
        Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Ok", style: TextStyle(fontFamily: ""),),
      onPressed:  () async{
        await renameAndSaveImage().then((value) {
          Get.back();
          Get.back();
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //title: Text("AlertDialog"),
      content: Text("Do You want to save?", style: TextStyle(fontFamily: ""),),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

