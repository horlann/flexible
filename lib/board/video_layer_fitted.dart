import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoLayerFittedToWidget extends StatefulWidget {
  final String videoAsset;
  final Color backgroundColor;
  const VideoLayerFittedToWidget({
    Key? key,
    required this.videoAsset,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  _VideoLayerFittedToWidgetState createState() =>
      _VideoLayerFittedToWidgetState();
}

class _VideoLayerFittedToWidgetState extends State<VideoLayerFittedToWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new VideoPlayerController.asset(widget.videoAsset,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  void didUpdateWidget(covariant VideoLayerFittedToWidget oldWidget) {
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

class VideoLayerFittedToBG extends StatefulWidget {
  final String videoAsset;
  final Color backgroundColor;
  const VideoLayerFittedToBG({
    Key? key,
    required this.videoAsset,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  _VideoLayerFittedToBGState createState() => _VideoLayerFittedToBGState();
}

class _VideoLayerFittedToBGState extends State<VideoLayerFittedToBG> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new VideoPlayerController.asset(widget.videoAsset,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  void didUpdateWidget(covariant VideoLayerFittedToBG oldWidget) {
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
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: widget.backgroundColor,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        alignment: Alignment.topCenter,
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
