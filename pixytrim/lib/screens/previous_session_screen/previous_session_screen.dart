import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/previous_session_screen_controller/previous_session_screen_controller.dart';
import 'package:pixytrim/screens/camera_screen/camera_screen.dart';
import 'package:share/share.dart';

import 'collage_session_screen/collage_session_screen.dart';

class PreviousSessionScreen extends StatefulWidget {
  PreviousSessionScreen({Key? key}) : super(key: key);

  @override
  _PreviousSessionScreenState createState() => _PreviousSessionScreenState();
}

class _PreviousSessionScreenState extends State<PreviousSessionScreen> with SingleTickerProviderStateMixin{
  final controller = Get.put(PreviousSessionScreenController());
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Obx(
            () => Stack(
              children: [
                MainBackgroundWidget(),
                controller.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        margin:
                            EdgeInsets.only(left: 15, right: 15, bottom: 20),
                        child: Column(
                          children: [
                            appBar(context),
                            const SizedBox(height: 20),
                            Expanded(child: draftData()),
                           // const SizedBox(height: 20),
                            tabView()

                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
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
                    child: Image.asset(
                      Images.ic_left_arrow,
                      scale: 2.4,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "Draft",
                    style: TextStyle(
                      fontFamily: "",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                controller.localSessionListNew.isNotEmpty ?
                GestureDetector(
                  onTap: () {
                    tabController.index == 0 ? deleteAllImagesAlertDialog(context) : Container();
                    print('index:: ${tabController.index}');
                  },
                  child: tabController.index == 0 ? Icon(Icons.delete_rounded) : Container(),
                  // child: controller.localSessionListNew.isNotEmpty && tabController.index == 0 ?
                  //   Container(child: Icon(Icons.delete_rounded)) : Container(),
                 ) :Container(),
                 /* : tabController.index == 1 ?
                 GestureDetector(
                   onTap: () {
                     deleteAllImagesAlertDialog(context);
                   },
                   //child: Icon(Icons.delete_rounded)),
                   child: controller.localSessionListNew.isNotEmpty ?
                   Container(child: Icon(Icons.delete_rounded)) : Container(),
                 )  Container(), */
              ],
            ),
        ),
      ),
    );
  }

  Widget draftData(){
    /*return ;*/
    return Obx(
      ()=> controller.isLoading.value
      ? Center(child: CircularProgressIndicator())
      : Container(
        child: TabBarView(
          controller: tabController,
          children: [

               Container(
                child: Obx(()=>
                   controller.localSessionListNew.length == 0
                      ? Center(
                    child: Text(
                      'No Local Data Available',
                      style: TextStyle(fontFamily: ""),
                    ),
                  )
                      :
                 /* GridView.builder(
                    itemCount:
                    controller.localSessionListNew.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: GestureDetector(
                          onTap: () {
                            if (controller.localSessionListNew.isNotEmpty) {
                              Get.off(() => CameraScreen(),
                                  arguments: [
                                    File(
                                        '${controller.localSessionListNew[index]}'),
                                    SelectedModule.gallery
                                  ]);
                            }
                          },
                          onLongPress: () {
                            deleteSingleImageAlertDialog(
                                context, index);
                          },
                          child: Container(
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(File(
                                    '${controller.localSessionListNew[index]}')),
                              ),
                            ),
                            // child: Image.file(File('${controller.localSessionListNew![index]}')),
                          ),
                        ),
                      );
                    },
                  ),*/
                  ListView.builder(
                  itemCount: controller.localSessionListNew.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: GestureDetector(
                          onTap: () {
                            if (controller.localSessionListNew.isNotEmpty) {
                              Get.off(() => CameraScreen(),
                                  arguments: [
                                    File(
                                        '${controller.localSessionListNew[index]}'),
                                    SelectedModule.gallery
                                  ]);
                            }
                          },
                          onLongPress: () {
                            deleteSingleImageAlertDialog(
                                context, index);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: FileImage(File(
                                        '${controller.localSessionListNew[index]}')),
                                  ),
                                ),
                                // child: Image.file(File('${controller.localSessionListNew![index]}')),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await shareImage(index);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.share),
                                        SizedBox(width: 5,),
                                        Text("Share", style: TextStyle(fontFamily: "", fontSize: 18),)
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 7,),
                                  GestureDetector(
                                    onTap: () async {
                                      await saveImage(index);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.download),
                                        SizedBox(width: 5,),
                                        Text("Save", style: TextStyle(fontFamily: "", fontSize: 18),)
                                      ],
                                    ),
                                  ),

                                  // SizedBox(height: 7,),
                                  // GestureDetector(
                                  //   onTap: () async {
                                  //     setState(() {
                                  //        controller.updateLocalSessionList(index);
                                  //     });
                                  //
                                  //   },
                                  //   child: Row(
                                  //     children: [
                                  //       Icon(Icons.delete),
                                  //       SizedBox(width: 5,),
                                  //       Text("Delete", style: TextStyle(fontFamily: "", fontSize: 18),)
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              )

                            ],
                          ),
                        ),
                      );
                    }
                )
                ),

              ),
            Container(
              child: controller.localCollageList.length == 0
                  ? Center(
                child: Text(
                  'No Collage Local Data Available',
                  style: TextStyle(fontFamily: ""),
                ),
              )
                  :
              /*GridView.builder(
                itemCount: controller.localCollageList.length,
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: FileImage(File(
                              '${controller.localCollageList[index]}')),
                        ),
                      ),
                      // child: Image.file(File('${controller.localSessionListNew![index]}')),
                    ),
                  );
                },
              ),*/
              ListView.builder(
                  itemCount: controller.localCollageList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(File(
                                    '${controller.localCollageList[index]}')),
                              ),
                            ),
                            // child: Image.file(File('${controller.localSessionListNew![index]}')),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await shareImage1(index);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.share),
                                    SizedBox(width: 5,),
                                    Text("Share", style: TextStyle(fontFamily: "", fontSize: 18),)
                                  ],
                                ),
                              ),
                              SizedBox(height: 7,),
                              GestureDetector(
                                onTap: () async {
                                  await saveImage1(index);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.download),
                                    SizedBox(width: 5,),
                                    Text("Save", style: TextStyle(fontFamily: "", fontSize: 18),)
                                  ],
                                ),
                              ),

                              // SizedBox(height: 7,),
                              // GestureDetector(
                              //   onTap: () async {
                              //     setState(() {
                              //        controller.updateLocalSessionList(index);
                              //     });
                              //
                              //   },
                              //   child: Row(
                              //     children: [
                              //       Icon(Icons.delete),
                              //       SizedBox(width: 5,),
                              //       Text("Delete", style: TextStyle(fontFamily: "", fontSize: 18),)
                              //     ],
                              //   ),
                              // ),
                            ],
                          )
                        ],
                      ),
                    );
                  }
              )
            ),
            //collageImagesPreviousSessionModule(),
          ],
        ),
      ),
    );
  }

  // Share The
  shareImage(int index) async {
    try {
      // final ByteData bytes = await rootBundle.load('${file!.path}');
      await Share.shareFiles(['${controller.localSessionListNew[index]}']);
    } catch (e) {
      print('Share Error : $e');
    }
  }

  shareImage1(int index) async {
    try {
      // final ByteData bytes = await rootBundle.load('${file!.path}');
      await Share.shareFiles(['${controller.localCollageList[index]}']);
    } catch (e) {
      print('Share Error : $e');
    }
  }

  Future saveImage(int index) async {
    // renameImage();
    await GallerySaver.saveImage(controller.localSessionListNew[index],
        albumName: "OTWPhotoEditingDemo");
    Fluttertoast.showToast(
        msg: "Save in to Gallery",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future saveImage1(int index) async {
    // renameImage();
    await GallerySaver.saveImage(controller.localCollageList[index],
        albumName: "OTWPhotoEditingDemo");
    Fluttertoast.showToast(
        msg: "Save in to Gallery",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget tabView(){
    return TabBar(
      indicatorColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: Colors.black,
      labelPadding: EdgeInsets.only(top: 20.0),
      unselectedLabelColor: Colors.grey,
      controller:  tabController,
      labelStyle: TextStyle(fontSize: 18),
      tabs: [
        Container(
          width: Get.width,
          margin: EdgeInsets.only(right: 5),
          decoration: borderGradientDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: containerBackgroundGradient(),
                child: Tab(text: "Image Draft")),
          ),
        ),
        Container(
          width: Get.width,
          margin: EdgeInsets.only(left: 5),
          decoration: borderGradientDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: containerBackgroundGradient(),
                child: Tab(text: "Collage Draft")),
          ),
        ),

      ],
    );
  }

  deleteAllImagesAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(fontFamily: ""),
      ),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(fontFamily: ""),
      ),
      onPressed: () async {
        controller.deleteLocalSessionList();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        "Do you want to delete All Images ?",
        style: TextStyle(fontFamily: ""),
      ),
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

  deleteSingleImageAlertDialog(BuildContext context, int index) {
    Widget cancelButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(fontFamily: ""),
      ),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(fontFamily: ""),
      ),
      onPressed: () async {
        controller.updateLocalSessionList(index);
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        "Do you want to delete this image ?",
        style: TextStyle(fontFamily: "",fontSize: 18),
      ),
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

  collageImagesPreviousSessionModule() {
    return GestureDetector(
      onTap: () {
        Get.to(()=> CollageSessionScreen());
      },
      child: Container(
        decoration: borderGradientDecoration(),
        child: Padding(
          padding: EdgeInsets.all(3),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: containerBackgroundGradient(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Collage Draft',
                  style: TextStyle(
                    fontFamily: "",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
