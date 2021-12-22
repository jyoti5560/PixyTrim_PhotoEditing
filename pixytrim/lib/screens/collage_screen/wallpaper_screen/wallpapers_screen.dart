import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/controller/collage_screen_conroller/collage_screen_controller.dart';

class WallPapersScreen extends StatelessWidget {
  WallPapersScreen({Key? key}) : super(key: key);
  final collageScreenController = Get.find<CollageScreenController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      height: 60,
      width: Get.width,
      margin: EdgeInsets.only(right: 8),
      decoration: borderGradientDecoration(),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: ListView.builder(
            itemCount: collageScreenController.wallpapers.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    collageScreenController.isActiveWallpaper.value = true;
                    collageScreenController.activeWallpaper.value = index;
                    print('selectedIndex : ${collageScreenController.activeWallpaper.value}');
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: AssetImage(collageScreenController.wallpapers[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          )
      ),

    );

  }
}
