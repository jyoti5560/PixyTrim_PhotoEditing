import 'dart:io';
import 'package:get/get.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/models/image_size_ratio_model/image_size_ratio_model.dart';
import 'package:pixytrim/screens/image_size_ratio_screen/image_size_ratio_screen_widgets.dart';


class ImageSizeRatioController extends GetxController {
  File file = Get.arguments;
  RxInt selectedIndex = 0.obs;
  List<ImageSizeRatioModel> sizeOptions = [];
  double blurImage = 6;

  @override
  void onInit() {

    sizeOptions = [
      ImageSizeRatioModel(
          sizeName: '1.2',
          image: Images.ic_sizeRatio1,
          sizeWidget: SizeRatio1()),
      ImageSizeRatioModel(
          sizeName: '2.3',
          image: Images.ic_sizeRatio2,
          sizeWidget: SizeRatio2()),
      ImageSizeRatioModel(
          sizeName: '3.2',
          image: Images.ic_sizeRatio3,
          sizeWidget: SizeRatio3()),
      ImageSizeRatioModel(
          sizeName: '3.4',
          image: Images.ic_sizeRatio4,
          sizeWidget: SizeRatio4()),
      ImageSizeRatioModel(
          sizeName: '4.3',
          image: Images.ic_sizeRatio5,
          sizeWidget: SizeRatio5()),
      ImageSizeRatioModel(
          sizeName: '5.4',
          image: Images.ic_sizeRatio6,
          sizeWidget: SizeRatio6()),
      ImageSizeRatioModel(
          sizeName: '9.16',
          image: Images.ic_sizeRatio7,
          sizeWidget: SizeRatio7()),
      ImageSizeRatioModel(
          sizeName: '16.9',
          image: Images.ic_sizeRatio8,
          sizeWidget: SizeRatio8()),
      ImageSizeRatioModel(
          sizeName: 'a4',
          image: Images.ic_sizeRatio9,
          sizeWidget: SizeRatio9()),
      ImageSizeRatioModel(
          sizeName: 'a5',
          image: Images.ic_sizeRatio10,
          sizeWidget: SizeRatio10()),
      ImageSizeRatioModel(
          sizeName: 'fb cover',
          image: Images.ic_sizeRatio11,
          sizeWidget: SizeRatio11()),
      ImageSizeRatioModel(
          sizeName: 'fb post',
          image: Images.ic_sizeRatio12,
          sizeWidget: SizeRatio12()),
      ImageSizeRatioModel(
          sizeName: 'ig story',
          image: Images.ic_sizeRatio13,
          sizeWidget: SizeRatio13()),
      ImageSizeRatioModel(
          sizeName: 'ig 1.1',
          image: Images.ic_sizeRatio14,
          sizeWidget: SizeRatio14()),
      ImageSizeRatioModel(
          sizeName: 'ig 4.5',
          image: Images.ic_sizeRatio15,
          sizeWidget: SizeRatio15()),
      ImageSizeRatioModel(
          sizeName: 'movie',
          image: Images.ic_sizeRatio16,
          sizeWidget: SizeRatio16()),
      ImageSizeRatioModel(
          sizeName: 'pinterest post',
          image: Images.ic_sizeRatio17,
          sizeWidget: SizeRatio17()),
      ImageSizeRatioModel(
          sizeName: 'twitter header',
          image: Images.ic_sizeRatio18,
          sizeWidget: SizeRatio18()),
      ImageSizeRatioModel(
          sizeName: 'twitter post',
          image: Images.ic_sizeRatio19,
          sizeWidget: SizeRatio19()),
      ImageSizeRatioModel(
          sizeName: 'youtube cover',
          image: Images.ic_sizeRatio20,
          sizeWidget: SizeRatio20()),
    ];

    super.onInit();
  }
}
