import 'dart:developer';

import 'package:flutter/material.dart';

class PlayerMenu extends StatefulWidget {
  Map<int, String> audioTracks;
  Function(int) onAudioTrackChanged;
  int selectedAudio;
  PlayerMenu({Key? key, required this.audioTracks,required this.selectedAudio,required this.onAudioTrackChanged})
      : super(key: key);

  @override
  State<PlayerMenu> createState() => _PlayerMenuState();
}

class _PlayerMenuState extends State<PlayerMenu> {
  String selectedMenuItem = "Audio";
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.37,
      width: MediaQuery.of(context).size.width * 0.30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: selectedMenuItem == ""
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                    child: Text(
                      "Settings",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                  ),
                  Column(
                    children: [menuItem(title: "Audio")],
                  ),
                ],
              )
            : selectedMenuDisp(),
      ),
    );
  }

  Widget selectedMenuDisp() {
    switch (selectedMenuItem) {
      case "Audio":
        return audioMenu();
      default:
        return audioMenu();
    }
  }

  Widget audioMenu() {
    return Container(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Text(
              "Select Audio",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child:Column(
                children: widget.audioTracks.entries.map((e) {
                  log("aud"+e.value);
              return ListTile(
                dense: true,
                onTap: () {
                  widget.onAudioTrackChanged(e.key);
                  setState(() {
                    widget.selectedAudio = e.key;
                    // selectedMenuItem = "";
                  });
                },
                trailing: widget.selectedAudio == e.key? Icon(Icons.check,color: Colors.green,):null,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(e.value),
                ),
              );
            }).toList()),
            ),
          )
      
        ],
      ),
    );
  }

  Widget menuItem({required String title}) {
    return ListTile(
      tileColor: Colors.grey[100],
      onTap: () {
        setState(() {
          selectedMenuItem = title;
        });
      },
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("$title"),
      ),
    );
  }
}
