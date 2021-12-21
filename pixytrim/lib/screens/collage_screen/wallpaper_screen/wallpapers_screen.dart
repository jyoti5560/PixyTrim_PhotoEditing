import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/controller/collage_screen_conroller/collage_screen_controller.dart';

class WallPapersScreen extends StatelessWidget {
  WallPapersScreen({Key? key}) : super(key: key);
  final collageScreenController = Get.find<CollageScreenController>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
              child: Image.asset(collageScreenController.wallpapers[index]),
            ),
          ),
        );
      },
    );
  }
}
