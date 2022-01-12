import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixytrim/common/custom_image.dart';

import 'package:pixytrim/screens/image_editor_screen/_image_painter.dart';
import 'package:pixytrim/screens/image_editor_screen/delegates/text_delegate.dart';


class SelectionItems extends StatelessWidget {
  final bool? isSelected;
  final ModeData? data;
  final VoidCallback? onTap;

  const SelectionItems({Key? key, this.isSelected, this.data, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: isSelected! ? Colors.blue : Colors.transparent),
      // child: ListTile(
      //   leading: IconTheme(
      //     data: const IconThemeData(opacity: 1.0),
      //     child: Image.asset('${data!.icon}',
      //         color: isSelected! ? Colors.white : Colors.black),
      //   ),
      //   title: Text(
      //     data!.label!,
      //     style: Theme.of(context).textTheme.subtitle1!.copyWith(
      //         color: isSelected!
      //             ? Colors.white
      //             : Theme.of(context).textTheme.bodyText1!.color),
      //   ),
      //   onTap: onTap,
      //   contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      //   selected: isSelected!,
      // ),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Image.asset('${data!.image}', scale: 2,),
                    SizedBox(width: 20,),

                    Expanded(
                      child: Text(
                          data!.label!,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontFamily: "",
                              fontSize: 16,
                              color: isSelected!
                                  ? Colors.white
                                  : Theme.of(context).textTheme.bodyText1!.color)),
                    ),
                ],
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}

List<ModeData> paintModes(TextDelegate textDelegate) => [
      // ModeData(
      //     image: Images.ic_zoom,
      //     mode: PaintMode.none,
      //     label: textDelegate.noneZoom),
      ModeData(
          image: Images.ic_line,
          mode: PaintMode.line,
          label: textDelegate.line),
      ModeData(
          image: Images.ic_rectangle,
          mode: PaintMode.rect,
          label: textDelegate.rectangle),
      ModeData(
          image: Images.ic_pencil,
          mode: PaintMode.freeStyle,
          label: textDelegate.drawing),
      ModeData(
          image: Images.ic_circle,
          mode: PaintMode.circle,
          label: textDelegate.circle),
      ModeData(
          image: Images.ic_right_arrow,
          mode: PaintMode.arrow,
          label: textDelegate.arrow),
      ModeData(
          image: Images.ic_dash_line,
          mode: PaintMode.dashLine,
          label: textDelegate.dashLine),
      /*ModeData(
          image: Images.ic_text,
          mode: PaintMode.text,
          label: textDelegate.text),*/
    ];

@immutable
class ModeData {
  final String? image;
  final PaintMode? mode;
  final String? label;
  const ModeData({
    this.image,
    this.mode,
    this.label,
  });
}
