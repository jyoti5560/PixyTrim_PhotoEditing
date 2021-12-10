import 'dart:io';
import 'dart:ui';

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
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
            child: Image.file(file)),
        ),

        Container(
        child: AspectRatio(
        aspectRatio:1/2,
          child: Image.file(file)),
        ),
      ],

    );
  }

  Widget sizeRatio2(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:2/3,
              child: Image.file(file)),
        ),
      ],

    );
  }

  Widget sizeRatio3(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:3/2,
              child: Image.file(file)),
        ),
      ],

    );
  }

  Widget sizeRatio4(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:3/4,
              child: Image.file(file)),
        ),
      ],

    );
  }

  Widget sizeRatio5(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:4/3,
              child: Image.file(file)),
        ),
      ],

    );
  }

  Widget sizeRatio6(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:5/4,
              child: Image.file(file)),
        ),
      ],

    );
  }

  Widget sizeRatio7(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:9/16,
              child: Image.file(file)),
        ),
      ],

    );
  }

  Widget sizeRatio8(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:16/9,
              child: Image.file(file)),
        ),
      ],

    );
  }

  Widget sizeRatio9(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:1/1.41,
              child: Image.file(file)),
        ),
      ],

    );
  }

  Widget sizeRatio10(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:1/1.41,
              child: Image.file(file)),
        ),
      ],

    );
  }

  Widget sizeRatio11(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:16/9,
              child: Image.file(file)),
        ),
      ],

    );
  }

  Widget sizeRatio12(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:1.91/1,
              child: Image.file(file)),
        ),
      ],

    );
  }

  Widget sizeRatio13(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:9/16,
              child: Image.file(file)),
        ),
      ],

    );
  }

  Widget sizeRatio14(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:1/1,
              child: Image.file(file)),
        ),
      ],

    );
  }

  Widget sizeRatio15(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:4/5,
              child: Image.file(file)),
        ),
      ],

    );
  }

  Widget sizeRatio16(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:2.39/1,
              child: Image.file(file)),
        ),
      ],

    );
  }

  Widget sizeRatio17(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:2/3,
              child: Image.file(file)),
        ),
      ],

    );
  }

  Widget sizeRatio18(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:3/1,
              child: Image.file(file)),
        ),
      ],

    );
  }
  Widget sizeRatio19(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:16/9,
              child: Image.file(file)),
        ),
      ],

    );
  }
  Widget sizeRatio20(){
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: blurImage, sigmaY: blurImage),
          child: Container(
              child: Image.file(file)),
        ),

        Container(
          child: AspectRatio(
              aspectRatio:16/9,
              child: Image.file(file)),
        ),
      ],

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