import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/collage_screen_conroller/collage_screen_controller.dart';
import 'package:pixytrim/controller/previous_session_screen_controller/previous_session_screen_controller.dart';
import 'package:pixytrim/models/collage_screen_model/single_image_file_model.dart';
import 'package:pixytrim/screens/camera_screen/camera_screen.dart';
import 'package:pixytrim/screens/collage_screen/collage_screen.dart';
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

  // List<UserDetails> _userDetails = [
  //   UserDetails(name: 'Pixytrim ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}'),
  //   UserDetails(name: 'Flutter ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}'),
  //   UserDetails(name: 'Flutter Flutter'),
  //   UserDetails(name: 'Flutter Flutter1'),
  //   // UserDetails(name: 'Pixytrim ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}'),
  //   // UserDetails(name: 'Pixytrim ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}'),
  //   // UserDetails(name: 'Pixytrim ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}'),
  //   // UserDetails(name: 'Pixytrim ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}'),
  //
  // ];

  DateTime time = DateTime.now();
  TextEditingController searchController = new TextEditingController();
  TextEditingController searchCollageController = new TextEditingController();
  final collageScreenController = Get.find<CollageScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                          const SizedBox(height: 10),
                          /*ListTile(
                            leading: new Icon(Icons.search),
                            title: new TextField(
                              controller: searchController,
                              decoration: new InputDecoration(
                                  hintText: 'Search', border: InputBorder.none),
                              onChanged: onSearchTextChanged,
                            ),
                            trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                              searchController.clear();
                              onSearchTextChanged('');
                            },),
                          ),*/
                          Expanded(
                              child: draftData()),
                         // const SizedBox(height: 20),
                          tabView()

                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    controller.searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    print("User list: ${controller.localSessionList}");
    //String local= controller.localSessionList.toString().split('cache/')[1];
    controller.localSessionList.forEach((userDetail) {
      print("user detail path: ${userDetail.split('cache/')[1]}");
      if (userDetail.split('cache/')[1].contains(text))
      {
        controller.searchResult.add(userDetail);
      }
    });

    setState(() {});
  }

  onSearchCollageTextChanged(String text) async {
    controller.searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    print("User list: ${controller.localCollageList}");
   // String local= controller.localSessionList.toString().split('cache/')[1];
    controller.localCollageList.forEach((userDetail) {
      print("user detail path: ${userDetail.split('cache/')[1]}");
      if (userDetail.split('cache/')[1].contains(text))
      {
        controller.searchResult.add(userDetail);
      }

    });

    setState(() {});
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

                controller.localSessionList.isNotEmpty ||
                      controller.localCollageList.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        // tabController.index == 0 ? deleteAllImagesAlertDialog(context) : deleteAllCollageImagesAlertDialog(context);
                        if (tabController.index == 0) {
                          deleteAllImagesAlertDialog(context);
                        } else {
                          deleteAllCollageImagesAlertDialog(context);
                        }
                        //tabController.index == 0 ? deleteAllImagesAlertDialog(context) : Container();
                        print('index:: ${tabController.index}');
                      },
                      child: Icon(Icons.delete_rounded),
                      // child: controller.localSessionListNew.isNotEmpty && tabController.index == 0 ?
                      //   Container(child: Icon(Icons.delete_rounded)) : Container(),
                    )
                  : Container(),
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
                child: Column(
                  children: [
                    Container(
                      height: 45,
                      decoration: borderGradientDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: containerBackgroundGradient(),
                          child: TextField(
                            controller: searchController,
                            decoration: new InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(fontFamily: ""),
                                labelStyle: TextStyle(fontFamily: "Times New Roman"),
                                helperStyle: TextStyle(fontFamily: ""),
                                prefixIcon: Icon(Icons.search, color: Colors.black,),
                                suffixIcon: GestureDetector(
                                    onTap: (){
                                      searchController.clear();
                                      onSearchTextChanged('');
                                    },
                                    child: Icon(Icons.close, color: searchController.text.isNotEmpty ? Colors.black: Colors.grey,)),
                                border: InputBorder.none),
                            onChanged: onSearchTextChanged,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Expanded(
                      child: Obx(()=>
                         controller.localSessionList.length == 0
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
                       controller.searchResult.length != 0 || searchController.text.isNotEmpty ?
                       ListView.builder(
                           itemCount: controller.searchResult.length,
                           scrollDirection: Axis.vertical,
                           shrinkWrap: true,
                           physics: AlwaysScrollableScrollPhysics(),
                           itemBuilder: (context, index){
                             return Padding(
                               padding: const EdgeInsets.all(5),
                               child: GestureDetector(
                                 onTap: () {
                                   if (controller.localSessionList.isNotEmpty) {
                                     Get.off(() => CameraScreen(),
                                         arguments: [
                                           File(
                                               '${controller.localSessionList[index]}'),
                                           SelectedModule.gallery
                                         ]);
                                   }
                                 },
                                 // onLongPress: () {
                                 //   deleteSingleImageAlertDialog(
                                 //       context, index);
                                 // },
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
                                               '${controller.searchResult[index]}')),
                                         ),
                                       ),
                                       // child: Image.file(File('${controller.localSessionListNew![index]}')),
                                     ),

                                     SizedBox(width: 5,),

                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       //mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         // Text("PixyTrim ${time.day}-${time.month}-${time.year} ${time.hour}:${time.minute}:${time.second}",
                                         //   style: TextStyle(fontFamily: ""),),
                                         Text(controller.searchResult[index].split('cache/')[1],
                                           style: TextStyle(fontFamily: "", fontSize: 16),),

                                         SizedBox(height: 10,),

                                         Row(
                                           //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             GestureDetector(
                                               onTap: () async {
                                                 await shareImage(index);
                                               },
                                               child: Container(
                                                 //width: Get.width,
                                                 height: 40,
                                                 //margin: EdgeInsets.only(right: 5),
                                                 decoration: borderGradientDecoration(),
                                                 child: Padding(
                                                     padding: const EdgeInsets.all(3.0),
                                                     child: Container(
                                                         padding: EdgeInsets.only(left: 10, right: 10),
                                                         decoration: containerBackgroundGradient(),
                                                         child: Icon(Icons.share),),
                                                 ),
                                               ),
                                             ),
                                              SizedBox(width: 10,),
                                             GestureDetector(
                                               onTap: () async {
                                                 await saveImage(index);
                                               },
                                               child: Container(
                                                 //width: Get.width,
                                                 height: 40,
                                                 //margin: EdgeInsets.only(right: 5),
                                                 decoration: borderGradientDecoration(),
                                                 child: Padding(
                                                   padding: const EdgeInsets.all(3.0),
                                                   child: Container(
                                                     padding: EdgeInsets.only(left: 10, right: 10),
                                                     decoration: containerBackgroundGradient(),
                                                     child: Icon(Icons.download),
                                                   ),
                                                 ),
                                               ),
                                             ),
                                             SizedBox(width: 10,),
                                             GestureDetector(
                                               onTap: () async {
                                                 deleteSingleImageAlertDialog(
                                                     context, index);
                                               },
                                               child: Container(
                                                 //width: Get.width,
                                                 height: 40,
                                                 //margin: EdgeInsets.only(right: 5),
                                                 decoration: borderGradientDecoration(),
                                                 child: Padding(
                                                   padding: const EdgeInsets.all(3.0),
                                                   child: Container(
                                                     padding: EdgeInsets.only(left: 10, right: 10),
                                                     decoration: containerBackgroundGradient(),
                                                     child: Icon(Icons.delete),
                                                   ),
                                                 ),
                                               ),
                                             ),
                                           ],
                                         )




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
                       ):
                        ListView.builder(
                          //itemCount: _userDetails.length,
                        itemCount: controller.localSessionList.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index){

                            print("local image list: ${controller.localSessionList[index]}");
                             //fileName = controller.localSessionList[index];
                            //File file = new File(controller.localSessionList[index]);
                            //String name = file.path.split('/').last;
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: GestureDetector(
                                onTap: () {
                                  if (controller.localSessionList.isNotEmpty) {
                                    Get.off(() => CameraScreen(),
                                        arguments: [
                                          File(
                                              '${controller.localSessionList[index]}'),
                                          SelectedModule.gallery
                                        ]);
                                  }
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
                                              '${controller.localSessionList[index]}')),
                                        ),
                                      ),
                                      // child: Image.file(File('${controller.localSessionListNew![index]}')),
                                    ),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        //mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // Text("PixyTrim ${time.day}-${time.month}-${time.year} ${time.hour}:${time.minute}:${time.second}",
                                          //   style: TextStyle(fontFamily: ""),),
                                          Text(controller.localSessionList[index].split('cache/')[1],
                                            style: TextStyle(fontFamily: "", fontSize: 16),),
                                          // Text("Pixytrim $index",
                                          //   style: TextStyle(fontFamily: ""),),

                                          SizedBox(height: 10,),

                                          Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  await shareImage(index);
                                                },
                                                child: Container(
                                                  //width: Get.width,
                                                  height: 40,
                                                  //margin: EdgeInsets.only(right: 5),
                                                  decoration: borderGradientDecoration(),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(3.0),
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 10, right: 10),
                                                      decoration: containerBackgroundGradient(),
                                                      child: Icon(Icons.share),),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10,),
                                              GestureDetector(
                                                onTap: () async {
                                                  await saveImage(index);
                                                },
                                                child: Container(
                                                  //width: Get.width,
                                                  height: 40,
                                                  //margin: EdgeInsets.only(right: 5),
                                                  decoration: borderGradientDecoration(),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(3.0),
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 10, right: 10),
                                                      decoration: containerBackgroundGradient(),
                                                      child: Icon(Icons.download),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10,),
                                              GestureDetector(
                                                onTap: () async {
                                                  deleteSingleImageAlertDialog(
                                                      context, index);
                                                },
                                                child: Container(
                                                  //width: Get.width,
                                                  height: 40,
                                                  //margin: EdgeInsets.only(right: 5),
                                                  decoration: borderGradientDecoration(),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(3.0),
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 10, right: 10),
                                                      decoration: containerBackgroundGradient(),
                                                      child: Icon(Icons.delete),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )

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
                                      ),
                                    )

                                  ],
                                ),
                              ),
                            );
                          }
                      )
                      ),
                    ),
                  ],
                ),

              ),
            Container(
              child: Column(
                children: [
                  /*TextField(
                    controller: searchCollageController,
                    decoration: new InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(fontFamily: ""),
                        labelStyle: TextStyle(fontFamily: "Times New Roman"),
                        helperStyle: TextStyle(fontFamily: ""),
                        prefixIcon: Icon(Icons.search, color: Colors.black,),
                        suffixIcon: GestureDetector(
                            onTap: (){
                              searchCollageController.clear();
                              onSearchCollageTextChanged('');
                            },
                            child: Icon(Icons.close, color: Colors.black,)),
                        border: InputBorder.none),
                    onChanged: onSearchCollageTextChanged,
                  ),
                  SizedBox(height: 5,),*/

                  Expanded(
                    child: Obx(()=>
                       controller.localCollageList.length == 0
                          ? Center(
                        child: Text(
                          'No Collage Data Available In Local',
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
                       controller.searchResult.length != 0 || searchController.text.isNotEmpty ?
                       ListView.builder(
                           itemCount: controller.searchResult.length,
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
                                             '${controller.searchResult[index]}')),
                                       ),
                                     ),
                                     // child: Image.file(File('${controller.localSessionListNew![index]}')),
                                   ),

                                   Row(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     //mainAxisAlignment: MainAxisAlignment.start,
                                     children: [
                                       GestureDetector(
                                         onTap: () async {
                                           await shareImage1(index);
                                         },
                                         child: Icon(Icons.share),
                                       ),
                                       SizedBox(height: 7,),
                                       GestureDetector(
                                         onTap: () async {
                                           await saveImage1(index);
                                         },
                                         child: Icon(Icons.download),
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
                       ):
                      ListView.builder(
                          itemCount: controller.localCollageList.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index){
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: (){
                                  Get.back();
                                  collageScreenController.imageFileList.clear();
                                  for(int i=0; i < controller.localCollageList.length; i++){
                                    File file = File('${controller.localCollageList[i]}');
                                    XFile xFile = XFile('${file.path}');
                                    collageScreenController.imageFileList.add(ImageFileItem(file: xFile));
                                  }
                                  Get.off(()=> CollageScreen());
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    SizedBox(width: 5,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      //mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            await shareImage1(index);
                                          },
                                          child: Container(
                                           // width: 110,
                                            height: 40,
                                            //margin: EdgeInsets.only(right: 5),
                                            decoration: borderGradientDecoration(),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Container(
                                                padding: EdgeInsets.only(left: 10, right: 10),
                                                decoration: containerBackgroundGradient(),
                                                child: Center(
                                                  child: Icon(Icons.share),
                                                ),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 7,),
                                        GestureDetector(
                                          onTap: () async {
                                            await saveImage1(index);
                                          },
                                          child: Container(
                                            //width: 110,
                                            height: 40,
                                            //margin: EdgeInsets.only(right: 5),
                                            decoration: borderGradientDecoration(),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Container(
                                                padding: EdgeInsets.only(left: 10, right: 10),
                                                decoration: containerBackgroundGradient(),
                                                child: Center(
                                                  child:Icon(Icons.download),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(width: 7,),
                                        GestureDetector(
                                          onTap: () async {
                                            deleteSingleImageCollageAlertDialog(
                                                context, index);
                                          },
                                          child: Container(
                                           // width: 110,
                                            height: 40,
                                            //margin: EdgeInsets.only(right: 5),
                                            decoration: borderGradientDecoration(),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Container(
                                                padding: EdgeInsets.only(left: 10, right: 10),
                                                decoration: containerBackgroundGradient(),
                                                child: Center(
                                                  child: Icon(Icons.delete),
                                                ),
                                              ),
                                            ),
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
                      ),
                    ),
                  ),
                ],
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
      await Share.shareFiles(['${controller.localSessionList[index]}']);
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
    await GallerySaver.saveImage(controller.localSessionList[index],
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
        if(controller.localSessionList.isEmpty){
          Fluttertoast.showToast(msg: 'List is Empty!');
          Get.back();
          // Get.back();
        } else {
        Fluttertoast.showToast(msg: 'Deleted Successfully!');
        Get.back();
        Get.back();

        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        "Do you want to delete all images ?",
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

  deleteAllCollageImagesAlertDialog(BuildContext context) {
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
        controller.deleteCollageLocalSessionList();
        if(controller.localCollageList.isEmpty) {
          Fluttertoast.showToast(msg: 'List is Empty!');
          Get.back();
          // Get.back();
        } else {
          Fluttertoast.showToast(msg: 'Deleted Successfully!');
          Get.back();
          Get.back();

        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        "Do you want to delete all images ?",
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

  deleteSingleImageCollageAlertDialog(BuildContext context, int index) {
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
        controller.updateLocalCollageSessionList(index);
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

/*
class UserDetails {
  //final int ? id;
  //final String ? image;
  final String ? name;

  UserDetails({required this.name});

  // factory UserDetails.fromJson(Map<String, dynamic> json) {
  //   return new UserDetails(
  //     id: json['id'],
  //     name: json['name'],
  //   );
  // }
}*/
