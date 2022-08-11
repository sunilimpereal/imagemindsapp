import 'dart:developer';

import 'package:flutter/material.dart';

class AudioSelector extends StatefulWidget {
  final Map<int, String> audioTracks;
  final Function(String) onTap;
  final String selectedAudio;
  const AudioSelector(
      {Key? key, required this.audioTracks, required this.selectedAudio, required this.onTap})
      : super(key: key);

  @override
  State<AudioSelector> createState() => _AudioSelectorState();
}

class _AudioSelectorState extends State<AudioSelector> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool isOpen = false;
  @override
  void initState() {
    super.initState();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    var size = renderBox!.size;
    return OverlayEntry(
        builder: (context) => Positioned(
            width: 300,
            child: CompositedTransformFollower(
                link: this._layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 5.0),
                child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(2),
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      height: widget.audioTracks.length < 3 ? widget.audioTracks.length * 50 : 150,
                      // width: 300,
                      child: ListView(
                          children: widget.audioTracks.toList((entry) => entry.value).map((e) {
                        return AudioTrackoption(
                            title: e,
                            onTap: () {
                              widget.onTap(e);
                              this._overlayEntry!.remove();
                              setState(() {
                                isOpen = false;
                              });
                            });
                      }).toList()),
                    )))));
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
        link: this._layerLink,
        child: GestureDetector(
            onTap: () {
              log(isOpen.toString());
              if (!isOpen) {
                this._overlayEntry = this._createOverlayEntry();
                Overlay.of(context)!.insert(this._overlayEntry!);
                setState(() {
                  isOpen = true;
                });
              } else {
                this._overlayEntry!.remove();
                setState(() {
                  isOpen = false;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                children: [
                  Text(widget.selectedAudio,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 24,
                  )
                ],
              ),
            )));
  }
}

class AudioTrackoption extends StatefulWidget {
  const AudioTrackoption({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final Function onTap;

  @override
  State<AudioTrackoption> createState() => _AudioTrackoptionState();
}

class _AudioTrackoptionState extends State<AudioTrackoption> {
  bool hover = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        child: InkWell(
          onTap: () {
            widget.onTap();
          },
          child: Container(
            width: 200,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
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

extension ListFromMap<Key, Element> on Map<Key, Element> {
  List<T> toList<T>(T Function(MapEntry<Key, Element> entry) getElement) =>
      entries.map(getElement).toList();
}
