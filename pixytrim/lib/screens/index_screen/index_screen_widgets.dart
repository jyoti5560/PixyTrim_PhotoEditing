import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';

class HeaderTextModule extends StatelessWidget {
  const HeaderTextModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Image.asset(Images.ic_logo, scale: 5,),
        ),
        SizedBox(height: 15,),
        Container(
          child: Text(
            "Pixy Trim",
            style: TextStyle(fontSize: 50, fontFamily: "Lemon Jelly"),
          ),
        ),
      ],
    );
  }
}

class GalleryModule extends StatelessWidget {
  const GalleryModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: borderGradientDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: containerBackgroundGradient(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Images.ic_gallery,
                    scale: 2.5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Gallery",
                    style:
                    TextStyle(fontFamily: "", fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CameraModule extends StatelessWidget {
  const CameraModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: borderGradientDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: containerBackgroundGradient(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Images.ic_camera,
                  scale: 2.5,
                ),
                SizedBox(width: 10),
                Text(
                  "Camera",
                  style: TextStyle(
                    fontFamily: "",
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CollageModule extends StatelessWidget {
  const CollageModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: borderGradientDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: containerBackgroundGradient(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Images.ic_layout,
                  scale: 4,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Collage",
                  style: TextStyle(
                    fontFamily: "",
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LocalStoreDataModule extends StatelessWidget {
  const LocalStoreDataModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: borderGradientDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: containerBackgroundGradient(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Images.ic_draft, scale: 2.5,),
                SizedBox(width: 10,),
                Text(
                  "Draft",
                  style: TextStyle(
                    fontFamily: "",
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddProfile extends StatelessWidget {
 // const AddProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: borderGradientDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: containerBackgroundGradient(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Images.ic_profile, scale: 2.8,),
                //Icon(Icons.person),
                SizedBox(width: 10,),
                Text(
                  "Profile",
                  style: TextStyle(
                    fontFamily: "",
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class LiveImageCaptureModule extends StatelessWidget {
  const LiveImageCaptureModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: borderGradientDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: containerBackgroundGradient(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Live Camera Capture",
                  style: TextStyle(
                    fontFamily: "",
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
