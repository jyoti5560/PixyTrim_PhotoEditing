import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
//import 'package:get/get.dart';
import 'package:pixytrim/common/common_widgets.dart';
import 'package:pixytrim/common/custom_image.dart';
import 'package:video_trimmer/video_trimmer.dart';

class TrimVideo extends StatefulWidget {
  //const TrimVideo({Key? key}) : super(key: key);
  final File file;
  TrimVideo({required this.file});

  @override
  _TrimVideoState createState() => _TrimVideoState();
}

class _TrimVideoState extends State<TrimVideo> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 100.0;
  bool _isPlaying = false;
  bool _progressVisibility = false;

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: SafeArea(
            child: Stack(
              children: [
                MainBackgroundWidget(),

                Column(
                  children: [

                    appBar(),

                    SizedBox(
                      height: 20,
                    ),

                    Visibility(
                      visible: _progressVisibility,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.red,
                      ),
                    ),

                    // Expanded(
                    //   child: Stack(
                    //     alignment: Alignment.center,
                    //     children: [
                    //       Container(
                    //         width: Get.width,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(20),
                    //           ),
                    //           child: VideoViewer(trimmer: _trimmer)
                    //           // child: ClipRRect(
                    //           //   borderRadius: BorderRadius.circular(20),
                    //           //     child: VideoViewer(trimmer: _trimmer))
                    //       ),
                    //
                    //       TextButton(
                    //         child: _isPlaying
                    //             ? Icon(
                    //           Icons.pause,
                    //           size: 80.0,
                    //           color: Colors.white,
                    //         )
                    //             : Icon(
                    //           Icons.play_arrow,
                    //           size: 80.0,
                    //           color: Colors.white,
                    //         ),
                    //         onPressed: () async {
                    //           bool playbackState = await _trimmer.videPlaybackControl(
                    //             startValue: _startValue,
                    //             endValue: _endValue,
                    //           );
                    //           setState(() {
                    //             _isPlaying = playbackState;
                    //           });
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    //
                    //
                    // ),
                    Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 25, right: 25),
                              width: Get.width,
                              height: double.infinity,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: VideoViewer(trimmer: _trimmer)),
                            ),

                          TextButton(
                            child: _isPlaying
                                ? Icon(
                              Icons.pause,
                              size: 80.0,
                              color: Colors.white,
                            )
                                : Icon(
                              Icons.play_arrow,
                              size: 80.0,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              bool playbackState = await _trimmer.videPlaybackControl(
                                startValue: _startValue,
                                endValue: _endValue,

                              );
                              setState(() {
                                _isPlaying = playbackState;
                              });
                            },
                          ),
                          ],
                        )
                    ),

                    SizedBox(height: 20,),

                    trimVideo(),
                    SizedBox(height: 20,),

                  ],
                ),
              ],

            ),
          ),
        )



      ),

      // body: SafeArea(
      //   child: Builder(
      //     builder: (context) => Center(
      //       child: Container(
      //         padding: EdgeInsets.only(bottom: 30.0),
      //         color: Colors.black,
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           mainAxisSize: MainAxisSize.max,
      //           children: <Widget>[
      //             Visibility(
      //               visible: _progressVisibility,
      //               child: LinearProgressIndicator(
      //                 backgroundColor: Colors.red,
      //               ),
      //             ),
      //             ElevatedButton(
      //               onPressed: _progressVisibility
      //                   ? null
      //                   : () async {
      //                 // _saveVideo().then((outputPath) {
      //                 //   print('OUTPUT PATH: $outputPath');
      //                 //   final snackBar = SnackBar(
      //                 //       content: Text('Video Saved successfully'));
      //                 //   ScaffoldMessenger.of(context).showSnackBar(
      //                 //     snackBar,
      //                 //   );
      //                 // });
      //               },
      //               child: Text("SAVE"),
      //             ),
      //             Expanded(
      //               child: VideoViewer(trimmer: _trimmer),
      //             ),
      //             Center(
      //               child: TrimEditor(
      //                 trimmer: _trimmer,
      //                 viewerHeight: 50.0,
      //                 viewerWidth: MediaQuery.of(context).size.width,
      //                 maxVideoLength: Duration(seconds: 120),
      //                 onChangeStart: (value) {
      //                   _startValue = value;
      //                 },
      //                 onChangeEnd: (value) {
      //                   _endValue = value;
      //                 },
      //                 onChangePlaybackState: (value) {
      //                   setState(() {
      //                     _isPlaying = value;
      //                   });
      //                 },
      //               ),
      //             ),
      //             TextButton(
      //               child: _isPlaying
      //                   ? Icon(
      //                 Icons.pause,
      //                 size: 80.0,
      //                 color: Colors.white,
      //               )
      //                   : Icon(
      //                 Icons.play_arrow,
      //                 size: 80.0,
      //                 color: Colors.white,
      //               ),
      //               onPressed: () async {
      //                 bool playbackState = await _trimmer.videPlaybackControl(
      //                   startValue: _startValue,
      //                   endValue: _endValue,
      //                 );
      //                 setState(() {
      //                   _isPlaying = playbackState;
      //                 });
      //               },
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget appBar() {
    return Container(
      height: 50,
      width: Get.width,
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: borderGradientDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: containerBackgroundGradient(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      child: Image.asset(Images.ic_left_arrow, scale: 2.5,)
                  ),
                ),
                Container(
                  child: Text(
                    "Trim Video",
                    style: TextStyle(
                        fontFamily: "",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap:  _progressVisibility ? null : ()async{
                    //Get.back();
                    //await _capturePng();
                    _saveVideo().then((outputPath) {
                      print('OUTPUT PATH: $outputPath');
                      final snackBar = SnackBar(
                          content: Text('Video Saved successfully'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        snackBar,
                      );
                    });
                  },
                  child: Container(
                      child: Image.asset(
                        Images.ic_downloading,
                        scale: 2,
                      )),
                ),
              ],
            )),
      ),
    );
  }

  trimVideo(){
    return Container(
      child: TrimEditor(
        durationTextStyle: TextStyle(fontFamily: "", fontSize: 16),
        trimmer: _trimmer,
        viewerHeight: 50.0,
        viewerWidth: MediaQuery.of(context).size.width,
        maxVideoLength: Duration(seconds: 360),
        onChangeStart: (value) {
          _startValue = value;
        },
        onChangeEnd: (value) {
          _endValue = value;
        },
        onChangePlaybackState: (value) {
          setState(() {
            _isPlaying = value;
          });
        },
      ),
    );
  }

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? _value;

    await _trimmer
        .saveTrimmedVideo(startValue: _startValue, endValue: _endValue)
        .then((value) async {
      setState(() {
        _progressVisibility = false;
        _value = value;

      });
      await GallerySaver.saveVideo("${_value!}", albumName: "OTWPhotoEditingDemo");
    });

    return _value;
  }
}
