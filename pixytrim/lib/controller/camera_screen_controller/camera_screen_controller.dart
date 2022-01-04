import 'dart:io';
import 'package:get/get.dart';
import 'package:pixytrim/models/filter_screen_model/single_filter_option.dart';
import 'package:flutter/material.dart';
import 'package:pixytrim/screens/filter_screen/filter_screen_widgets.dart';

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
      SingleFilterOption(filterWidget: noFilter(),filterName: 'No Filter', filterListWidget: noFilterList(width: 100, height: 100, fit: BoxFit.cover)),
      SingleFilterOption(filterWidget: filter1(),filterName: 'Filter 1', filterListWidget: filter1List(width: 100, height: 100, fit: BoxFit.cover)),
      SingleFilterOption(filterWidget: filter2(),filterName: 'Filter 2', filterListWidget: filter2(width: 100, height: 100, fit: BoxFit.cover)),
      SingleFilterOption(filterWidget: filter3(),filterName: 'Filter 3', filterListWidget: filter3(width: 100, height: 100, fit: BoxFit.cover)),
      SingleFilterOption(filterWidget: filter4(),filterName: 'Filter 4', filterListWidget: filter4(width: 100, height: 100, fit: BoxFit.cover)),
      SingleFilterOption(filterWidget: filter5(),filterName: 'Filter 5', filterListWidget: filter5(width: 100, height: 100, fit: BoxFit.cover)),
      SingleFilterOption(filterWidget: filter6(),filterName: 'Filter 6', filterListWidget: filter6(width: 100, height: 100, fit: BoxFit.cover)),
      SingleFilterOption(filterWidget: filter7(),filterName: 'Filter 7', filterListWidget: filter7(width: 100, height: 100, fit: BoxFit.cover)),
      SingleFilterOption(filterWidget: filter8(),filterName: 'Filter 8', filterListWidget: filter8(width: 100, height: 100, fit: BoxFit.cover)),
      SingleFilterOption(filterWidget: filter9(),filterName: 'Filter 9', filterListWidget: filter9(width: 100, height: 100, fit: BoxFit.cover)),
      SingleFilterOption(filterWidget: filter10(),filterName: 'Filter 10', filterListWidget: filter10(width: 100, height: 100, fit: BoxFit.cover)),
    ];
    super.onInit();
  }

  addCameraImageInList({required File file}) {

    addImageFromCameraList.add(file);
    print('addImageFromCameraList : ${addImageFromCameraList.length}');
  }

  List<SingleFilterOption> filterOptions = [];

  Widget noFilter({double? width, double? height, BoxFit? fit}){
    return Obx(
      ()=> Container(
        width: width ?? null,
        height: height ?? null,
        child: Image.file(addImageFromCameraList[selectedImage.value],
          width: width ?? null,
          height: height ?? null,
          fit: fit ?? null,
        ),
      ),
    );
  }

  Widget filter1({double? width, double? height, BoxFit? fit}){
    return Obx(
      ()=> Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              0.9,0.5,0.1,0.0,0.0,
              0.3,0.8,0.1,0.0,0.0,
              0.2,0.3,0.5,0.0,0.0,
              0.0,0.0,0.0,1.0,0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,fit: fit ?? null,),
        ),
      ),
    );
  }

  Widget filter2({double? width, double? height, BoxFit? fit}){
    return Obx(
      ()=> Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              0.3,-0.3,1.1,0.0,0.0,
              0.0,0.8,0.2,0.0,0.0,
              0.0,0.0,0.8,0.2,0.0,
              0.0,0.0,0.0,1.0,0.0
            ]),
            child: Image.file(
              addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,fit: fit ?? null,),),
      ),
    );
  }

  Widget filter3({double? width, double? height, BoxFit? fit}){
    return Obx(
      ()=> Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              2.1,0.0,0.0,0.0,0.0,
              -0.2,1.0,0.3,0.1,0.0,
              -0.1,0.0,1.0,0.0,0.0,
              0.0,0.0,0.0,1.0,0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,fit: fit ?? null,),
        ),
      ),
    );
  }

  Widget filter4({double? width, double? height, BoxFit? fit}){
    return Obx(
      ()=> Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              0.0,1.0,0.0,0.0,0.0,
              0.0,1.0,0.0,0.0,0.0,
              0.0,1.0,0.0,0.0,0.0,
              0.0,1.0,0.0,1.0,0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,fit: fit ?? null,
            )),
      ),
    );
  }

  Widget filter5({double? width, double? height, BoxFit? fit}){
    return Obx(
      ()=> Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              0.8, 0.5, 0.0, 0.0, 0.0,
              0.0, 1.1,0.0, 0.0, 0.0,
              0.0, 0.2, 1.1 , 0.0, 0.0,
              0.0, 0.0, 0.0, 1.0, 0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,fit: fit ?? null,)),
      ),
    );
  }

  Widget filter6({double? width, double? height, BoxFit? fit}){
    return Obx(
      ()=> Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              1.1, 0.0, 0.0, 0.0, 0.0,
              0.2, 1.0,-0.4, 0.0, 0.0,
              -0.1, 0.0, 1.0 , 0.0, 0.0,
              0.0, 0.0, 0.0, 1.0, 0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,fit: fit ?? null,)),
      ),
    );
  }

  Widget filter7({double? width, double? height, BoxFit? fit}){
    return Obx(
      ()=> Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              1.2, 0.1, 0.5, 0.0, 0.0,
              0.1, 1.0,0.05, 0.0, 0.0,
              0.0, 0.1, 1.0 , 0.0, 0.0,
              0.0, 0.0, 0.0, 1.0, 0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,fit: fit ?? null,)),
      ),
    );
  }

  Widget filter8({double? width, double? height, BoxFit? fit}){
    return Obx(
      ()=> Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              0.4, 0.4, -0.3, 0.0, 0.0,
              0.0, 1.0, 0.0, 0.0, 0.0,
              0.0, 0.0, 1.2, 0.0, 0.0,
              -1.2, 0.6, 0.7, 1.0, 0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,fit: fit ?? null,)),
      ),
    );
  }

  Widget filter9({double? width, double? height, BoxFit? fit}){
    return Obx(
      ()=> Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              1.0, 0.0, 0.2, 0.0, 0.0,
              0.0, 1.0, 0.0, 0.0, 0.0,
              0.0, 0.0, 1.0, 0.0, 0.0,
              0.0, 0.0, 0.0, 1.0, 0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,fit: fit ?? null,)),
      ),
    );
  }

  Widget filter10({double? width, double? height, BoxFit? fit}){
    return Obx(
      ()=> Container(
        width: width ?? null,
        height: height ?? null,
        child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              0.2126, 0.7152, 0.0722, 0.0, 0.0,
              0.2126, 0.7152, 0.0722, 0.0, 0.0,
              0.2126, 0.7152, 0.0722, 0.0, 0.0,
              0.0, 0.0, 0.0, 1.0, 0.0
            ]),
            child: Image.file(
                addImageFromCameraList[selectedImage.value],
              width: width ?? null,
              height: height ?? null,fit: fit ?? null,)),
      ),
    );
  }

  loading() {
    isLoading(true);
    isLoading(false);
  }
}