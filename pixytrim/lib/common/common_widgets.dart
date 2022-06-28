import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:overlay_support/overlay_support.dart';

import 'custom_color.dart';
import 'custom_image.dart';

BoxDecoration borderGradientDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    gradient: LinearGradient(
      colors: [
        AppColor.kBorderGradientColor1,
        AppColor.kBorderGradientColor2,
        AppColor.kBorderGradientColor3,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}

BoxDecoration containerBackgroundGradient() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    image: DecorationImage(
      image: AssetImage('${Images.ic_btn_bg1}'),
      fit: BoxFit.cover,
    ),
  );
}

showTopNotification({
  required String displayText,
  required Widget leadingIcon,
  int? displayTime,
}) {
  return showSimpleNotification(
    Text(
      displayText,
      // "Saved to photo Gallery",
      style: TextStyle(
        color: AppColor.kBlackColor,
        fontSize: 16,
      ),
    ),
    leading: leadingIcon,
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    background: AppColor.kButtonCyanColor,
    position: NotificationPosition.top,
    duration: Duration(seconds: displayTime ?? 3),
    autoDismiss: true,
    elevation: 2,
  );
}

class MainBackgroundWidget extends StatelessWidget {
  const MainBackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      child: Image.asset(
        Images.ic_background2,
        fit: BoxFit.cover,
      ),
    );
  }
}

BoxDecoration liveCameraFramesButtonDecoration() {
  return BoxDecoration(shape: BoxShape.circle, color: Colors.black38
      // gradient: LinearGradient(
      //   colors: [
      //     AppColor.kBorderGradientColor1,
      //     AppColor.kBorderGradientColor2,
      //     AppColor.kBorderGradientColor3,
      //   ],
      //   begin: Alignment.topLeft,
      //   end: Alignment.bottomRight,
      // ),
      );
}
