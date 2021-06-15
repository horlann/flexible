import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoLayerFitted extends StatefulWidget {
  final String videoAsset;
  final Color backgroundColor;
  const VideoLayerFitted({
    Key? key,
    required this.videoAsset,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  _VideoLayerFittedState createState() => _VideoLayerFittedState();
}

class _VideoLayerFittedState extends State<VideoLayerFitted> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAsset)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  void didUpdateWidget(covariant VideoLayerFitted oldWidget) {
    super.didUpdateWidget(oldWidget);
    // _controller.dispose();
    // _controller = VideoPlayerController.asset(widget.videoAsset)
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {
    //       _controller.play();
    //       _controller.setLooping(true);
    //     });
    //   });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: FittedBox(
        clipBehavior: Clip.antiAlias,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        child: _controller.value.isInitialized
            ? Container(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
