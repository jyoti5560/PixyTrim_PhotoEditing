import 'package:get/get.dart';
import 'package:pixytrim/controller/collage_screen_conroller/collage_screen_controller.dart';

final collageScreenController = Get.find<CollageScreenController>();

void onLongPressModule({required int index}) {
  collageScreenController.imageFileList[index].isVisible
  = !collageScreenController.imageFileList[index].isVisible;
  
  for(int i = 0; i< collageScreenController.imageFileList.length; i++){
    if(i != index) {
      collageScreenController.imageFileList[i].isVisible = false;
    }
  }
}