// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:disk_space/disk_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:imagemindsapp/main.dart';
import 'package:imagemindsapp/subpages/grade/screens/widgets/player_menu.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';
import 'dart:io';
import 'package:wakelock/wakelock.dart';

class LandscapeVedioPlayer extends StatefulWidget {
  String vedioName;
  String title;
  LandscapeVedioPlayer({Key? key, required this.vedioName, required this.title}) : super(key: key);

  @override
  _LandscapeVedioPlayerState createState() => _LandscapeVedioPlayerState();
}

class _LandscapeVedioPlayerState extends State<LandscapeVedioPlayer> {
  late VlcPlayerController controller;
  bool initialised = false;
  bool showOverlay = true;
  bool extracting = false;
  String error = "";
  double sliderValue = 0.0;
  bool isVideoNotFound = false;
  bool vidInitialised = false;
  final stopwatch = Stopwatch()..start();
  Duration vidduration = Duration(seconds: 20);
  @override
  void initState() {
    initialize();
    super.initState();
  }

  void getDuration() async {
    Duration vdur = await controller.getDuration();
    setState(() {
      vidduration = vdur;
    });
  }

  void initialize() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    if (sharedPref.source == "cloud") {
      print("online player1");
      // online
      try {
        controller = VlcPlayerController.network(
          "https://iminds.s3.ap-south-1.amazonaws.com/videos/${widget.vedioName}.mp4",
          hwAcc: HwAcc.disabled,
          options: VlcPlayerOptions(),
        );

        // ..addListener(() {
        //   setState(() {});
        // })
        // ..setLooping(true);
        // await controller.initialize();
        // controller.play();
        setState(() {
          getDuration();
          initialised = true;
        });

        // log(controller.toString());
        // log(controller.value.toString());
        // if (controller.value.duration.inSeconds == 0) {
        //   setState(() {
        //     error = "Video not found";
        //   });
        // }

        controller.addListener(() {
          Wakelock.enable();

          setState(() {
            sliderValue = controller.value.position.inSeconds.toDouble();
            if (controller.value.position.inMilliseconds.toDouble() > 0) {
              vidInitialised = true;
            }
          });
        });
      } catch (e) {
        log("files : $e");
        setState(() {
          error = "Video not found";
        });
      }
    } else {
      print("offline player1");
      //offline
      try {
        if (widget.vedioName.contains("Demo")) {
          var path = await ExternalPath.getExternalStorageDirectories();
          File video = File("${path[1]}/Classes/${widget.vedioName}.mp4");
          log(video.path);
          controller = VlcPlayerController.file(
            video,
            hwAcc: HwAcc.disabled,
            options: VlcPlayerOptions(),
          );
          setState(() {
            initialised = true;
          });
          controller.addListener(() {
            setState(() {
              sliderValue = controller.value.position.inSeconds.toDouble();
              Wakelock.enable();
            });
          });
        } else {
          getVedio().then((value) {
            controller = VlcPlayerController.file(
              value ?? File(widget.vedioName),
              hwAcc: HwAcc.disabled,
              options: VlcPlayerOptions(),
            );
            // ..addListener(() {
            // })
            // ..setLooping(true)
            // ..initialize().then((value) {
            //   controller.play();
            setState(() {
              getDuration();
              initialised = true;
            });
            controller.addListener(() {
              setState(() {
                sliderValue = controller.value.position.inSeconds.toDouble();
                Wakelock.enable();
              });
            });
            // });
          });
        }
      } catch (e) {
        log("files : $e");
      }
    }
  }

  // Future<File> getVedioBinary() async {
  //   //decrypt and store vedio in app directory
  //   final appDirectory = await getApplicationDocumentsDirectory();
  //   var path = await ExternalPath.getExternalStorageDirectories();
  //   double? space = await DiskSpace.getFreeDiskSpaceForPath(appDirectory.path);
  //   File e = File("${path[1]}/Classes/${widget.vedioName}.mp4");
  //   String data = e.readAsStringSync();
  //   List<int> list = data.codeUnits;
  //   log(list.toString());
  //   Uint8List bytes = Uint8List.fromList(list);
  //   File output = await File("${appDirectory.path}/Classes/output.mp4")
  //       .writeAsBytes(list, mode: FileMode.write);
  //   return output;
  // }

  Future<File?> getVedio() async {
    try {
      //decrypt and store vedio in app directory
      var crypt = AesCrypt();
      final appDirectory = await getApplicationDocumentsDirectory();
      crypt.setPassword('password');
      crypt.aesSetMode(AesMode.ofb);
      crypt.setOverwriteMode(AesCryptOwMode.on);
      var path = await ExternalPath.getExternalStorageDirectories();
      // var path = await ExternalPath.DIRECTORY_DOWNLOADS;

      double? space = await DiskSpace.getFreeDiskSpaceForPath(appDirectory.path);
      log("space L $space");

      if (!File("${appDirectory.path}/${widget.vedioName}.mp4").existsSync()) {
        log("file : ${appDirectory.path}/${widget.vedioName}.mp4");
        setState(() {
          extracting = true;
        });
        if (space != null ? space <= 800 : false) {
          log("deleting");
          List<FileSystemEntity> fileList = [];
          fileList = Directory(appDirectory.path).listSync();
          for (FileSystemEntity file in fileList) {
            if (file.path.contains("preview")) {
              await file.delete();
            }
          }
          log("files: " + fileList.toString());
        }

        // String decryptedFile = crypt.decryptFileSync("${path[1]}/Classes/${widget.vedioName}.mp4",
        //     "${appDirectory.path}/${widget.vedioName}.mp4");
        File decrypFile = File(await crypt.decryptFile("${path[1]}/Classes/${widget.vedioName}.mp4",
            "${appDirectory.path}/${widget.vedioName}.mp4"));
        var externalPath = await ExternalPath.getExternalStorageDirectories();
        log(path[1]); // [/storage/emulated/0, /storage/B3AE-4D28]
        final directory = await getApplicationDocumentsDirectory();
        File vedioFile = File("${appDirectory.path}/${widget.vedioName}.mp4").absolute;
        log(vedioFile.path);
        setState(() {
          extracting = false;
        });
        return decrypFile;

        // log(decryptedFile);
      } else {
        return File("${appDirectory.path}/${widget.vedioName}.mp4");
      }
    } catch (e) {
      log("get video : $e");
      setState(() {
        isVideoNotFound = true;
      });
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await controller.stopRendererScanning();
    await controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getDuration();
    log(stopwatch.elapsed.toString());
    if (stopwatch.elapsed.compareTo(Duration(seconds: 5)) > 0) {
      if (this.mounted) {
        setState(() {
          showOverlay = false;
        });
      }
    }
    if (controller.value.position.inSeconds >= vidduration.inSeconds - 1) {
      setState(() {
        log("sdurat" + vidduration.inSeconds.toString());
        controller.seekTo(Duration(milliseconds: 0));
      });
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: error != ""
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.orange,
                ),
                onPressed: () async {
                  controller.pause();
                  await controller.stop();
                  await controller.stopRendererScanning();
                  Future.delayed(Duration(milliseconds: 100)).then((value) {
                    Navigator.pop(context);
                  });
                },
              ),
            )
          : null,
      body: extracting
          ? isVideoNotFound
              ? vedioNotFound()
              : extractionScreen()
          : initialised
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      showOverlay = true;
                      stopwatch.reset();
                      stopwatch.start();
                    });
                    // if (!showOverlay) {
                    //   log("message");
                    //   setState(() {
                    //     showOverlay = true;
                    //     t.tick;
                    //     t = Timer(const Duration(seconds: 5), () {
                    //       if (showOverlay) {
                    //         setState(() {
                    //           showOverlay = false;
                    //         });
                    //       }
                    //     });
                    //   });
                    // }
                  },
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          log("tappingf");
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      AbsorbPointer(
                        child: Center(
                          child: Container(
                            child: VlcPlayer(
                              controller: controller,
                              aspectRatio: 16 / 9,
                              placeholder: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                        ),
                      ),
                      showOverlay
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      stopwatch.stop();
                                      controller.pause();
                                      await controller.stop();
                                      await controller.stopRendererScanning();
                                      Future.delayed(Duration(milliseconds: 300)).then((value) {
                                        Navigator.pop(context);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      "${widget.title}",
                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(),
                      showOverlay
                          ? Container(
                              height: MediaQuery.of(context).size.height,
                              child: Stack(
                                children: [
                                  // Positioned(
                                  //     bottom: 20,
                                  //     right: 0,
                                  //     child: IconButton(
                                  //       icon: Icon(
                                  //         Icons.settings,
                                  //         color: Colors.white,
                                  //       ),
                                  //       onPressed: () async {
                                  //         Map<int, String> aud = await controller.getAudioTracks();
                                  //         aud.forEach((key, value) {
                                  //           log(key.toString() + value.toString());
                                  //         });
                                  //         showMaterialModalBottomSheet(
                                  //           context: context,
                                  //           builder: (context) => Container(),
                                  //         );
                                  //       },
                                  //     )),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  controller.value.position
                                                      .toString()
                                                      .substring(0, 7),
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Container(
                                              child: GestureDetector(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    color: Colors.black,
                                                  ),
                                                  padding: EdgeInsets.all(8),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.subtitles,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  Map<int, String> aud =
                                                      await controller.getAudioTracks();
                                                  aud.forEach((key, value) {
                                                    log(key.toString() + value.toString());
                                                  });
                                                  int? selectedTrack =
                                                      await controller.getAudioTrack();
                                                  showMaterialModalBottomSheet(
                                                    context: context,
                                                    backgroundColor: Colors.transparent,
                                                    builder: (context) => Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        PlayerMenu(
                                                          audioTracks: aud,
                                                          selectedAudio: selectedTrack ?? 1,
                                                          onAudioTrackChanged: (newNum) {
                                                            setState(() {
                                                              controller.setAudioTrack(newNum);
                                                            });
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        height: 18,
                                        child: Slider(
                                            value: sliderValue,
                                            min: 0.0,
                                            max: controller.value.duration.inSeconds == 0
                                                ? 1.0
                                                : controller.value.duration.inSeconds.toDouble(),
                                            onChanged: (progress) {
                                              setState(() {
                                                sliderValue = progress.floor().toDouble();
                                                if (sliderValue.isInfinite || sliderValue.isNaN) {
                                                } else {
                                                  controller.setTime(sliderValue.toInt() * 1000);
                                                }
                                              });
                                            }),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      showOverlay
                          ? Center(
                              child: IconButton(
                                icon: vidInitialised
                                    ? Icon(
                                        controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 64,
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                onPressed: () {
                                  setState(() {
                                    if (controller.value.isPlaying) {
                                      controller.pause();
                                    } else {
                                      controller.play();
                                    }
                                  });
                                },
                              ),
                            )
                          : Container(),
                    ],
                  ),
                )
              : Container(),
    );
  }

  Widget extractionScreen() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.orange),
            Text("Extracting Video...."),
            Text("This can take a while.Do not close the app during this process"),
          ],
        ),
      ),
    );
  }

  Widget vedioNotFound() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 55,
            color: Colors.orange,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Video Not Found",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "${controller.dataSource}".replaceAll("file://", ""),
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      )),
    );
  }
}

class RectClipper extends CustomClipper<Rect> {
  BuildContext context;
  RectClipper({required this.context});
  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
        0, 0, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height - 15);
  }
}
