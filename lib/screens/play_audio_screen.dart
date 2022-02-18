import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({Key key}) : super(key: key);

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

class _AudioPlayerState extends State<AudioPlayer> {
  @override
  void initState() {
    super.initState();
    setUpPlaylist();
  }

  void setUpPlaylist() async {
    await audioPlayer.open(Audio('assets/audio/beach.mp3'), autoStart: false);
  }

  Widget circularAudioPlayer(RealtimePlayingInfos rtpi, double ScreenWidth) {
    Color primaryColor = Colors.white;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 80),
        CircularPercentIndicator(
          radius: ScreenWidth / 2,
          arcType: ArcType.HALF,
          backgroundColor: primaryColor,
          progressColor: Colors.white,
          percent: rtpi.currentPosition.inSeconds / rtpi.duration.inSeconds,
          center: IconButton(
            iconSize: ScreenWidth / 2,
            color: primaryColor,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Icon(rtpi.isPlaying
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded),
            onPressed: () => audioPlayer.playOrPause(),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/beach.jpg'),
                    fit: BoxFit.cover)),
            alignment: Alignment.center,
            child: audioPlayer.builderRealtimePlayingInfos(
                builder: (context, realTimePlayingInfo) {
              if (realTimePlayingInfo != null) {
                return circularAudioPlayer(
                    realTimePlayingInfo, MediaQuery.of(context).size.width);
              } else {
                return Container();
              }
            })));
  }
}
