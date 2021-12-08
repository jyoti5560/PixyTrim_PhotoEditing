import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/controller/collage_screen_conroller/collage_screen_controller.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {

  CollageScreenController collageScreenController =
  Get.find<CollageScreenController>();



  @override
  Widget build(BuildContext context) {
    return collageScreenController.imageFileList.length == 2
        ? twoImageSelectCollageModule() :
          collageScreenController.imageFileList.length == 3
            ? threeImageSelectCollageModule() :
              Container();
  }

  Widget twoImageSelectCollageModule(){
    return ListView.builder(
      itemCount: collageScreenController.twoImageLayout.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      //physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                collageScreenController.selectedIndex.value = index;
                print(
                    'selectedIndex : ${collageScreenController.selectedIndex.value}');
              });
            },
            child: Container(
                child: Image.asset(collageScreenController.twoImageLayout[index]),
            // child: Container(
            //   padding: EdgeInsets.all(2),
            //   height: 60,
            //   width: 60,
            //   margin: EdgeInsets.only(right: 8),
            //   decoration: borderGradientDecoration(),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10),
            //       color: Colors.white,
            //     ),
            //     //margin: EdgeInsets.only(left: 10, right: 10),
            //
            //     child: Center(
            //         child: Text(index.toString(),
            //           style: TextStyle(fontFamily: "", fontSize: 18),)),
            //   ),
            ),
          ),
        );
      },
    );
  }

  Widget threeImageSelectCollageModule(){
    return ListView.builder(
      itemCount: collageScreenController.threeImageLayout.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      //physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                collageScreenController.selectedIndex.value = index;
                print(
                    'selectedIndex : ${collageScreenController.selectedIndex.value}');
              });
            },
            child: Container(
              child: Image.asset(collageScreenController.threeImageLayout[index]),
              // child: Container(
              //   padding: EdgeInsets.all(2),
              //   height: 60,
              //   width: 60,
              //   margin: EdgeInsets.only(right: 8),
              //   decoration: borderGradientDecoration(),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       color: Colors.white,
              //     ),
              //     //margin: EdgeInsets.only(left: 10, right: 10),
              //
              //     child: Center(
              //         child: Text(index.toString(),
              //           style: TextStyle(fontFamily: "", fontSize: 18),)),
              //   ),
            ),
          ),
        );
      },
    );
  }

}
