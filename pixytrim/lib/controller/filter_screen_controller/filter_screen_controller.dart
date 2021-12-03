import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixytrim/models/filter_screen_model/single_filter_option.dart';

class FilterScreenController extends GetxController{
  File file = Get.arguments;
  RxInt selectedIndex = 0.obs;


  List<SingleFilterOption> filterOptions = [];

  Widget noFilter(){
    return Container(
      child: Image.file(file, height: 120, width: 120, fit: BoxFit.fill),
    );
  }

  Widget filter1(){
    return Container(
      child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            0.9,0.5,0.1,0.0,0.0,
            0.3,0.8,0.1,0.0,0.0,
            0.2,0.3,0.5,0.0,0.0,
            0.0,0.0,0.0,1.0,0.0
          ]),
          child: Image.file(file, height: 120, width: 120, fit: BoxFit.fill)),
    );
  }

  Widget filter2(){
    return Container(
      child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            0.3,-0.3,1.1,0.0,0.0,
            0.0,0.8,0.2,0.0,0.0,
            0.0,0.0,0.8,0.2,0.0,
            0.0,0.0,0.0,1.0,0.0
          ]),
          child: Image.file(file, height: 120, width: 120, fit: BoxFit.fill)),
    );
  }

  Widget filter3(){
    return Container(
      child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            2.1,0.0,0.0,0.0,0.0,
            -0.2,1.0,0.3,0.1,0.0,
            -0.1,0.0,1.0,0.0,0.0,
            0.0,0.0,0.0,1.0,0.0
          ]),
          child: Image.file(file, height: 120, width: 120, fit: BoxFit.fill)),
    );
  }

  Widget filter4(){
    return Container(
      child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            0.0,1.0,0.0,0.0,0.0,
            0.0,1.0,0.0,0.0,0.0,
            0.0,1.0,0.0,0.0,0.0,
            0.0,1.0,0.0,1.0,0.0
          ]),
          child: Image.file(file, height: 120, width: 120, fit: BoxFit.fill)),
    );
  }

  Widget filter5(){
    return Container(
      child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            0.8, 0.5, 0.0, 0.0, 0.0,
            0.0, 1.1,0.0, 0.0, 0.0,
            0.0, 0.2, 1.1 , 0.0, 0.0,
            0.0, 0.0, 0.0, 1.0, 0.0
          ]),
          child: Image.file(file, height: 120, width: 120, fit: BoxFit.fill)),
    );
  }

  Widget filter6(){
    return Container(
      child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            1.1, 0.0, 0.0, 0.0, 0.0,
            0.2, 1.0,-0.4, 0.0, 0.0,
            -0.1, 0.0, 1.0 , 0.0, 0.0,
            0.0, 0.0, 0.0, 1.0, 0.0
          ]),
          child: Image.file(file, height: 120, width: 120, fit: BoxFit.fill)),
    );
  }

  Widget filter7(){
    return Container(
      child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            1.2, 0.1, 0.5, 0.0, 0.0,
            0.1, 1.0,0.05, 0.0, 0.0,
            0.0, 0.1, 1.0 , 0.0, 0.0,
            0.0, 0.0, 0.0, 1.0, 0.0
          ]),
          child: Image.file(file, height: 120, width: 120, fit: BoxFit.fill)),
    );
  }

  Widget filter8(){
    return Container(
      child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            0.4, 0.4, -0.3, 0.0, 0.0,
            0.0, 1.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 1.2, 0.0, 0.0,
            -1.2, 0.6, 0.7, 1.0, 0.0
          ]),
          child: Image.file(file, height: 120, width: 120, fit: BoxFit.fill)),
    );
  }

  Widget filter9(){
    return Container(
      child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            1.0, 0.0, 0.2, 0.0, 0.0,
            0.0, 1.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 1.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 1.0, 0.0
          ]),
          child: Image.file(file, height: 120, width: 120, fit: BoxFit.fill)),
    );
  }

  Widget filter10(){
    return Container(
      child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            0.2126, 0.7152, 0.0722, 0.0, 0.0,
            0.2126, 0.7152, 0.0722, 0.0, 0.0,
            0.2126, 0.7152, 0.0722, 0.0, 0.0,
            0.0, 0.0, 0.0, 1.0, 0.0
          ]),
          child: Image.file(file, height: 120, width: 120, fit: BoxFit.fill)),
    );
  }

  @override
  void onInit() {
    // filterOptions = [
    //   noFilter(),
    //   filter1(), filter2(), filter3(), filter4(), filter5(),
    //   filter6(), filter7(), filter8(), filter9(), filter10(),];

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
}