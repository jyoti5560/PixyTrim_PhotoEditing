import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/controller/collage_screen_conroller/collage_screen_controller.dart';

class BorderColorScreen extends StatefulWidget {
  //const BorderColorScreen({Key? key}) : super(key: key);
  @override
  _BorderColorScreenState createState() => _BorderColorScreenState();
}

class _BorderColorScreenState extends State<BorderColorScreen> {
  CollageScreenController collageScreenController =
  Get.find<CollageScreenController>();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2),
        height: 60,
        width: Get.width,
        margin: EdgeInsets.only(right: 8),
        decoration: borderGradientDecoration(),
        child: Container(
          // padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),

          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              // physics: BouncingScrollPhysics(),
              itemCount: collageScreenController.borderColor.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: GestureDetector(
                    onTap: (){
                      collageScreenController.activeColor.value = index;
                      print(
                          'selectedIndex : ${collageScreenController.borderColor[collageScreenController.activeColor.value]}');
                    },
                    child: Container(
                      height: 5, width: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: collageScreenController.borderColor[index],
                        shape: BoxShape.rectangle
                      ),
                    ),
                  ),
                );
              })
        ));
  }
}
