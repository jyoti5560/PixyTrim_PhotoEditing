import 'dart:io';
import 'package:get/get.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:pixytrim/models/image_size_ratio_model/image_size_ratio_model.dart';
import 'package:pixytrim/screens/image_size_ratio_screen/image_size_ratio_screen_widgets.dart';


class ImageSizeRatioController extends GetxController {
  File file = Get.arguments[0];
  int currentIndex = Get.arguments[1];
  RxInt selectedIndex = 0.obs;
  List<ImageSizeRatioModel> sizeOptions = [];
  double blurImage = 6;
  RxInt scaleIndex = 0.obs;

  @override
  void onInit() {

    sizeOptions = [
      ImageSizeRatioModel(
          sizeName: '1.2',
          image: Images.ic_sizeRatio1,
          sizeWidget: SizeRatio1(file: file)),
      ImageSizeRatioModel(
          sizeName: '2.3',
          image: Images.ic_sizeRatio2,
          sizeWidget: SizeRatio2(file: file)),
      ImageSizeRatioModel(
          sizeName: '3.2',
          image: Images.ic_sizeRatio3,
          sizeWidget: SizeRatio3(file: file)),
      ImageSizeRatioModel(
          sizeName: '3.4',
          image: Images.ic_sizeRatio4,
          sizeWidget: SizeRatio4(file: file)),
      ImageSizeRatioModel(
          sizeName: '4.3',
          image: Images.ic_sizeRatio5,
          sizeWidget: SizeRatio5(file: file)),
      ImageSizeRatioModel(
          sizeName: '5.4',
          image: Images.ic_sizeRatio6,
          sizeWidget: SizeRatio6(file: file)),
      ImageSizeRatioModel(
          sizeName: '9.16',
          image: Images.ic_sizeRatio7,
          sizeWidget: SizeRatio7(file: file)),
      ImageSizeRatioModel(
          sizeName: '16.9',
          image: Images.ic_sizeRatio8,
          sizeWidget: SizeRatio8(file: file)),
      ImageSizeRatioModel(
          sizeName: 'a4',
          image: Images.ic_sizeRatio9,
          sizeWidget: SizeRatio9(file: file)),
      ImageSizeRatioModel(
          sizeName: 'a5',
          image: Images.ic_sizeRatio10,
          sizeWidget: SizeRatio10(file: file)),
      ImageSizeRatioModel(
          sizeName: 'fb Mobile cover',
          image: Images.ic_sizeRatio11,
          sizeWidget: SizeRatio11(file: file)),
      ImageSizeRatioModel(
          sizeName: 'fb post',
          image: Images.ic_sizeRatio12,
          sizeWidget: SizeRatio12(file: file)),
      ImageSizeRatioModel(
          sizeName: 'ig story',
          image: Images.ic_sizeRatio13,
          sizeWidget: SizeRatio13(file: file)),
      ImageSizeRatioModel(
          sizeName: 'ig 1.1',
          image: Images.ic_sizeRatio14,
          sizeWidget: SizeRatio14(file: file)),
      ImageSizeRatioModel(
          sizeName: 'ig 4.5',
          image: Images.ic_sizeRatio15,
          sizeWidget: SizeRatio15(file: file)),
      ImageSizeRatioModel(
          sizeName: 'movie',
          image: Images.ic_sizeRatio16,
          sizeWidget: SizeRatio16(file: file)),
      ImageSizeRatioModel(
          sizeName: 'pinterest post',
          image: Images.ic_sizeRatio17,
          sizeWidget: SizeRatio17(file: file)),
      ImageSizeRatioModel(
          sizeName: 'twitter header',
          image: Images.ic_sizeRatio18,
          sizeWidget: SizeRatio18(file: file)),
      ImageSizeRatioModel(
          sizeName: 'twitter post',
          image: Images.ic_sizeRatio19,
          sizeWidget: SizeRatio19(file: file)),
      ImageSizeRatioModel(
          sizeName: 'youtube cover',
          image: Images.ic_sizeRatio20,
          sizeWidget: SizeRatio20(file: file)),
    ];

    super.onInit();
  }
}
