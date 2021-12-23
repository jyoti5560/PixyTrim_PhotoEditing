import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        ? twoImageSelectCollageModule()
        : collageScreenController.imageFileList.length == 3
            ? threeImageSelectCollageModule()
            : collageScreenController.imageFileList.length == 4
                ? fourImageSelectCollageModule()
                : collageScreenController.imageFileList.length == 5
                    ? fiveImageSelectCollageModule()
                    : collageScreenController.imageFileList.length == 6
                        ? sixImageSelectCollageModule()
                        : collageScreenController.imageFileList.length == 7
                            ? sevenImageSelectCollageModule()
                            : Container();
  }

  Widget twoImageSelectCollageModule() {
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
            ),
          ),
        );
      },
    );
  }

  Widget threeImageSelectCollageModule() {
    return ListView.builder(
      itemCount: collageScreenController.threeImageLayout.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
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
              child:
                  Image.asset(collageScreenController.threeImageLayout[index]),
            ),
          ),
        );
      },
    );
  }

  Widget fourImageSelectCollageModule() {
    return ListView.builder(
      itemCount: collageScreenController.fourImageLayout.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
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
              child:
                  Image.asset(collageScreenController.fourImageLayout[index]),
            ),
          ),
        );
      },
    );
  }

  Widget fiveImageSelectCollageModule() {
    return ListView.builder(
      itemCount: collageScreenController.fiveImageLayout.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
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
              child:
                  Image.asset(collageScreenController.fiveImageLayout[index]),
            ),
          ),
        );
      },
    );
  }

  Widget sixImageSelectCollageModule() {
    return ListView.builder(
      itemCount: collageScreenController.sixImageLayout.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
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
              child: Image.asset(collageScreenController.sixImageLayout[index]),
            ),
          ),
        );
      },
    );
  }

  Widget sevenImageSelectCollageModule() {
    return ListView.builder(
      itemCount: collageScreenController.sevenImageLayout.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
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
              child:
                  Image.asset(collageScreenController.sevenImageLayout[index]),
            ),
          ),
        );
      },
    );
  }
}
