import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/models/image_size_ratio_model/image_size_ratio_model.dart';

class ImageSizeRatioController extends GetxController{
  File file = Get.arguments;
  RxInt selectedIndex = 0.obs;
  List<ImageSizeRatioModel> sizeOptions = [];
  double blurImage = 6;

  Widget sizeRatio1(){
    return Container(
        child: AspectRatio(
        aspectRatio:1/2,
          child: Image.file(file, fit: BoxFit.fill,)),
    );

  }

  Widget sizeRatio2(){
    return Container(
      width: Get.width / 1.2,
          child: AspectRatio(
              aspectRatio:2/3,
              child: Image.file(file, fit: BoxFit.fill,)),
        );
  }

  Widget sizeRatio3(){
    return Container(
      padding: EdgeInsets.only(top: 40, bottom: 40),
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(20),
      //     border: Border.all(color: Colors.grey)
      // ),
          child: AspectRatio(
              aspectRatio:3/2,
              child: Image.file(file,fit: BoxFit.fill,)),
    );
  }

  Widget sizeRatio4(){
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
          //width: Get.width,
          child: Container(
            width: Get.width/1.3,

            child: AspectRatio(
                aspectRatio:3/4,
                child: Image.file(file, fit: BoxFit.fill,)),
          ),
    );
  }

  Widget sizeRatio5(){
    return Container(
      width: Get.width/1.2,
      padding: EdgeInsets.only(top: 30, bottom: 30),
          child: AspectRatio(
              aspectRatio:4/3,
              child: Image.file(file, fit: BoxFit.fill,)),
    );
  }

  Widget sizeRatio6(){
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: AspectRatio(
          aspectRatio: 5/4,
          child: Image.file(file, fit: BoxFit.fill,)),
    );
  }

  Widget sizeRatio7(){
    return Container(
      child: AspectRatio(
          aspectRatio: 9/16,
          child: Image.file(file, fit: BoxFit.fill,)),
    );
  }

  Widget sizeRatio8(){
    return Container(
      padding: EdgeInsets.only(top: 40, bottom: 40),
      child: AspectRatio(
          aspectRatio: 16/9,
          child: Image.file(file, fit: BoxFit.fill,)),
    );
  }

  Widget sizeRatio9(){
    return Container(
      width: Get.width/1.2,
          child: AspectRatio(
              aspectRatio:1/1.41,
              child: Image.file(file, fit: BoxFit.fill,)),
    );
  }

  Widget sizeRatio10(){
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 30),
      width: Get.width/1.3,
          child: AspectRatio(
              aspectRatio:1/1.41,
              child: Image.file(file, fit: BoxFit.fill,)),

    );
  }

  Widget sizeRatio11(){
    return Container(
      padding: EdgeInsets.only(top: 160, bottom: 160),
          child: AspectRatio(
              aspectRatio:16/9,
              child: Image.file(file, fit: BoxFit.fill,)),
    );
  }

  Widget sizeRatio12(){
    return Container(
      padding: EdgeInsets.only(top: 100, bottom: 100),
          child: AspectRatio(
              aspectRatio:1.91/1,
              child: Image.file(file, fit: BoxFit.fill,)),
    );
  }

  Widget sizeRatio13(){
    return Container(
      width: Get.width/2,
          child: AspectRatio(
              aspectRatio:9/16,
              child: Image.file(file, fit: BoxFit.fill,)),
    );
  }

  Widget sizeRatio14(){
    return Container(
          child: AspectRatio(
              aspectRatio:1/1,
              child: Image.file(file, fit: BoxFit.fill,)),
    );
  }

  Widget sizeRatio15(){
    return Container(
      width: Get.width/1.3,
          child: AspectRatio(
              aspectRatio:4/5,
              child: Image.file(file, fit: BoxFit.fill,)),
    );
  }

  Widget sizeRatio16(){
    return Container(
      padding: EdgeInsets.only(top: 180, bottom: 180),
          child: AspectRatio(
              aspectRatio:2.39/1,
              child: Image.file(file, fit: BoxFit.fill,)),
    );
  }

  Widget sizeRatio17(){
    return Container(
      width: Get.width/1.3,
      child: AspectRatio(
          aspectRatio:4/5,
          child: Image.file(file, fit: BoxFit.fill,)),
    );
  }

  Widget sizeRatio18(){
    return Container(
      padding: EdgeInsets.only(top: 150, bottom: 150),
      child: AspectRatio(
          aspectRatio:2.39/1,
          child: Image.file(file, fit: BoxFit.fill,)),
    );
  }
  Widget sizeRatio19(){
    return Container(
      padding: EdgeInsets.only(top: 130, bottom: 130),
      child: AspectRatio(
          aspectRatio:2.39/1,
          child: Image.file(file, fit: BoxFit.fill,)),
    );
  }
  Widget sizeRatio20(){
    return Container(
      padding: EdgeInsets.only(top: 180, bottom: 180),
      child: AspectRatio(
          aspectRatio:2.39/1,
          child: Image.file(file, fit: BoxFit.fill,)),
    );
  }

  @override
  void onInit() {
    // filterOptions = [
    //   noFilter(),
    //   filter1(), filter2(), filter3(), filter4(), filter5(),
    //   filter6(), filter7(), filter8(), filter9(), filter10(),];

    sizeOptions = [
      ImageSizeRatioModel(sizeName: '1.2', image: Images.ic_sizeRatio1, sizeWidget: sizeRatio1()),
      ImageSizeRatioModel(sizeName: '2.3', image: Images.ic_sizeRatio2, sizeWidget: sizeRatio2()),
      ImageSizeRatioModel(sizeName: '3.2', image: Images.ic_sizeRatio3, sizeWidget: sizeRatio3()),
      ImageSizeRatioModel(sizeName: '3.4', image: Images.ic_sizeRatio4, sizeWidget: sizeRatio4()),
      ImageSizeRatioModel(sizeName: '4.3', image: Images.ic_sizeRatio5, sizeWidget: sizeRatio5()),
      ImageSizeRatioModel(sizeName: '5.4', image: Images.ic_sizeRatio6, sizeWidget: sizeRatio6()),
      ImageSizeRatioModel(sizeName: '9.16', image: Images.ic_sizeRatio7, sizeWidget: sizeRatio7()),
      ImageSizeRatioModel(sizeName: '16.9', image: Images.ic_sizeRatio8, sizeWidget: sizeRatio8()),
      ImageSizeRatioModel(sizeName: 'a4', image: Images.ic_sizeRatio9, sizeWidget: sizeRatio9()),
      ImageSizeRatioModel(sizeName: 'a5', image: Images.ic_sizeRatio10, sizeWidget: sizeRatio10()),
      ImageSizeRatioModel(sizeName: 'fb cover', image: Images.ic_sizeRatio11, sizeWidget: sizeRatio11()),
      ImageSizeRatioModel(sizeName: 'fb post', image: Images.ic_sizeRatio12, sizeWidget: sizeRatio12()),
      ImageSizeRatioModel(sizeName: 'ig story', image: Images.ic_sizeRatio13, sizeWidget: sizeRatio13()),
      ImageSizeRatioModel(sizeName: 'ig 1.1', image: Images.ic_sizeRatio14, sizeWidget: sizeRatio14()),
      ImageSizeRatioModel(sizeName: 'ig 4.5', image: Images.ic_sizeRatio15, sizeWidget: sizeRatio15()),
      ImageSizeRatioModel(sizeName: 'movie', image: Images.ic_sizeRatio16, sizeWidget: sizeRatio16()),
      ImageSizeRatioModel(sizeName: 'pinterest post', image: Images.ic_sizeRatio17, sizeWidget: sizeRatio17()),
      ImageSizeRatioModel(sizeName: 'twitter header', image: Images.ic_sizeRatio18, sizeWidget: sizeRatio18()),
      ImageSizeRatioModel(sizeName: 'twitter post', image: Images.ic_sizeRatio19, sizeWidget: sizeRatio19()),
      ImageSizeRatioModel(sizeName: 'youtube cover', image: Images.ic_sizeRatio20, sizeWidget: sizeRatio20()),
    ];

    super.onInit();
  }
}