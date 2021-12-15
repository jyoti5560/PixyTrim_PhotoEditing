import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:image_painter/image_painter.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Stack(
      //   children: [
      //     MainBackgroundWidget(),
      //
      //     Container(
      //       margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
      //       child: Column(
      //         children: [
      //           SizedBox(
      //             height: 60,
      //           ),
      //           appBar(),
      //
      //           SizedBox(height: 20,),
      //
      //           imageEditingcon(),
      //
      //           SizedBox(height: 20,),
      //
      //           Expanded(
      //               child: Container(
      //                 width: Get.width,
      //                 child: ClipRRect(
      //                   borderRadius: BorderRadius.circular(20),
      //                   child: widget.file.toString().isNotEmpty
      //                       ? Image.file(widget.file,
      //                       height: 120, width: 120, fit: BoxFit.fill)
      //                       : null,
      //                 ),
      //               ))
      //         ],
      //       ),
      //     )
      //   ],
      // ),

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
                    Get.back();
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
                    //Get.back();
                    await renameAndSaveImage().then((value) {
                      Fluttertoast.showToast(
                          msg: "Save in to Gallery",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      Get.back();
                    });
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

  Widget imageEditingcon(){
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
    // var image = await _imageKey.currentState!.exportImage().toString();
    // String ogPath = _imageKey.currentState!.exportImage().toString();
    // String frontPath = ogPath.split('cache')[0];
    // print('frontPath: $frontPath');
    // List<String> ogPathList = ogPath.split('/');
    // print('ogPathList: $ogPathList');
    // String ogExt = ogPathList[ogPathList.length - 1].split('.')[1];
    // print('ogExt: $ogExt');
    // DateTime today = new DateTime.now();
    // String dateSlug = "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year.toString()}_${today.hour.toString().padLeft(2, '0')}-${today.minute.toString().padLeft(2, '0')}-${today.second.toString().padLeft(2, '0')}";
    // widget.file = await widget.file.rename("${frontPath}cache/PhotoEditingDemo_$dateSlug.$ogExt");
    // print('File : ${widget.file}');
    // print('File Path : ${widget.file.path}');
    final image = await _imageKey.currentState!.exportImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/sample').create(recursive: true);
    final fullPath = '$directory/sample/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final imgFile = File('$fullPath');
    imgFile.writeAsBytesSync(image!);
    await GallerySaver.saveImage(imgFile.path, albumName: "OTWPhotoEditingDemo");
  }
}

