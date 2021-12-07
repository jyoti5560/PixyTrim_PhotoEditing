import 'package:flutter/material.dart';

class ColorItem extends StatelessWidget {
  const ColorItem({Key? key, this.onTap, this.isSelected, this.color})
      : super(key: key);
  final VoidCallback? onTap;
  final bool? isSelected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 8, bottom: 8),
        decoration: BoxDecoration(
            //color: isSelected! ? Colors.white70 : Colors.transparent,
            //shape: BoxShape.rectangle,
            // border: Border.all(
            //     color: isSelected! ? Colors.black : Colors.grey[200]!)
        ),
        child: Container(
          height: 20, width: 20,
            color: color
        ),
        // child: CircleAvatar(
        //     radius: isSelected! ? 16 : 12, backgroundColor: color),
      ),
    );
  }
}

const List<Color> editorColors = [
  Colors.black,
  Colors.grey,
  Colors.red,
  Colors.blue,
  Colors.deepPurpleAccent,
  Colors.blueAccent,
  Colors.green,
  Colors.lightGreen,
  Colors.pinkAccent,
  Colors.yellow,
  Colors.brown,
  Colors.teal

];
