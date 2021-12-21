import 'dart:io';
import 'package:get/get.dart';
import 'package:pixytrim/models/filter_screen_model/single_filter_option.dart';
import 'package:flutter/material.dart';

class CameraScreenController extends GetxController{
  RxBool isLoading = false.obs;
  File file = Get.arguments[0];
  final selectedModule = Get.arguments[1];

  RxInt selectedIndex = 0.obs;

  RxInt selectedImage = 0.obs;

  RxDouble compressSize = 61.0.obs;
  RxList<File> addImageFromCameraList = <File>[].obs;


  @override
  void onInit() {
    // Image List Clear And Add 1st Image in List
    addImageFromCameraList.clear();
    print('addImageFromCameraList 1 : ${addImageFromCameraList.length}');
    addImageFromCameraList.add(file);
    print('addImageFromCameraList 2 : ${addImageFromCameraList.length}');
    print('selected:---${selectedImage.value}');

    // Add All Filter in List
    filterOptions = [
      SingleFilterOption(filterWidget: noFilter(),filterName: 'No Filter'),
      SingleFilterOption(filterWidget: filter1(),filterName: 'Filter 1'),
      SingleFilterOption(filterWidget: filter2(),filterName: 'Filter 2'),
      SingleFilterOption(filterWidget: filter3(),filterName: 'Filter 3'),
      SingleFilterOption(filterWidget: filter4(),filterName: 'Filter 4'),
      SingleFilterOption(filterWidget: filter5(),filterName: 'Filter 5'),
      SingleFilterOption(filterWidget: filter6(),filterName: 'Filter 6'),
      SingleFilterOption(filterWidget: filter7(),filterName: 'Filter 7'),
      SingleFilterOption(filterWidget: filter8(),filterName: 'Filter 8'),
      SingleFilterOption(filterWidget: filter9(),filterName: 'Filter 9'),
      SingleFilterOption(filterWidget: filter10(),filterName: 'Filter 10'),
    ];
    super.onInit();
  }

  addCameraImageInList({required File file}) {

    addImageFromCameraList.add(file);
    print('addImageFromCameraList : ${addImageFromCameraList.length}');
  }

  List<SingleFilterOption> filterOptions = [];

  Widget noFilter(){
    return Obx(
      ()=> Container(
        child: Image.file(addImageFromCameraList[selectedImage.value], height: 120, width: 120, fit: BoxFit.fill),
      ),
    );
  }

  Widget filter1(){
    return Obx(
      ()=> Container(
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              0.9,0.5,0.1,0.0,0.0,
              0.3,0.8,0.1,0.0,0.0,
              0.2,0.3,0.5,0.0,0.0,
              0.0,0.0,0.0,1.0,0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
                height: 120, width: 120, fit: BoxFit.fill),
        ),
      ),
    );
  }

  Widget filter2(){
    return Obx(
      ()=> Container(
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              0.3,-0.3,1.1,0.0,0.0,
              0.0,0.8,0.2,0.0,0.0,
              0.0,0.0,0.8,0.2,0.0,
              0.0,0.0,0.0,1.0,0.0
            ]),
            child: Image.file(
              addImageFromCameraList[selectedImage.value],
              height: 120, width: 120, fit: BoxFit.fill),),
      ),
    );
  }

  Widget filter3(){
    return Obx(
      ()=> Container(
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              2.1,0.0,0.0,0.0,0.0,
              -0.2,1.0,0.3,0.1,0.0,
              -0.1,0.0,1.0,0.0,0.0,
              0.0,0.0,0.0,1.0,0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
                height: 120, width: 120, fit: BoxFit.fill),
        ),
      ),
    );
  }

  Widget filter4(){
    return Obx(
      ()=> Container(
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              0.0,1.0,0.0,0.0,0.0,
              0.0,1.0,0.0,0.0,0.0,
              0.0,1.0,0.0,0.0,0.0,
              0.0,1.0,0.0,1.0,0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
                height: 120, width: 120, fit: BoxFit.fill)),
      ),
    );
  }

  Widget filter5(){
    return Obx(
      ()=> Container(
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              0.8, 0.5, 0.0, 0.0, 0.0,
              0.0, 1.1,0.0, 0.0, 0.0,
              0.0, 0.2, 1.1 , 0.0, 0.0,
              0.0, 0.0, 0.0, 1.0, 0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
                height: 120, width: 120, fit: BoxFit.fill)),
      ),
    );
  }

  Widget filter6(){
    return Obx(
      ()=> Container(
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              1.1, 0.0, 0.0, 0.0, 0.0,
              0.2, 1.0,-0.4, 0.0, 0.0,
              -0.1, 0.0, 1.0 , 0.0, 0.0,
              0.0, 0.0, 0.0, 1.0, 0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
                height: 120, width: 120, fit: BoxFit.fill)),
      ),
    );
  }

  Widget filter7(){
    return Obx(
      ()=> Container(
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              1.2, 0.1, 0.5, 0.0, 0.0,
              0.1, 1.0,0.05, 0.0, 0.0,
              0.0, 0.1, 1.0 , 0.0, 0.0,
              0.0, 0.0, 0.0, 1.0, 0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
                height: 120, width: 120, fit: BoxFit.fill)),
      ),
    );
  }

  Widget filter8(){
    return Obx(
      ()=> Container(
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              0.4, 0.4, -0.3, 0.0, 0.0,
              0.0, 1.0, 0.0, 0.0, 0.0,
              0.0, 0.0, 1.2, 0.0, 0.0,
              -1.2, 0.6, 0.7, 1.0, 0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
                height: 120, width: 120, fit: BoxFit.fill)),
      ),
    );
  }

  Widget filter9(){
    return Obx(
      ()=> Container(
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              1.0, 0.0, 0.2, 0.0, 0.0,
              0.0, 1.0, 0.0, 0.0, 0.0,
              0.0, 0.0, 1.0, 0.0, 0.0,
              0.0, 0.0, 0.0, 1.0, 0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
                height: 120, width: 120, fit: BoxFit.fill)),
      ),
    );
  }

  Widget filter10(){
    return Obx(
      ()=> Container(
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              0.2126, 0.7152, 0.0722, 0.0, 0.0,
              0.2126, 0.7152, 0.0722, 0.0, 0.0,
              0.2126, 0.7152, 0.0722, 0.0, 0.0,
              0.0, 0.0, 0.0, 1.0, 0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
                height: 120, width: 120, fit: BoxFit.fill)),
      ),
    );
  }

  loading() {
    isLoading(true);
    isLoading(false);
  }
}