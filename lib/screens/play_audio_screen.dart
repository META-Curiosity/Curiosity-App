import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:percent_indicator/percent_indicator.dart';
import './mindful_completion_screen.dart';

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
  }

  String image = '';
  String audio = '';
  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context).settings.arguments as int;
    //Set the image and audio based on the setting selected.
    if (args == 0) {
      image = 'assets/images/food.jpg';
      audio = 'assets/audio/beach.mp3';
      print("0");
    } else if (args == 1) {
      image = 'assets/images/forest.jpeg';
      audio = 'assets/audio/forest.mp3';
      print("1");
    } else {
      image = 'assets/images/beach.jpg';
      audio = 'assets/audio/beach.mp3';
      print("2");
    }
    setUpPlaylist(audio);
    super.didChangeDependencies();
  }

  void setUpPlaylist(String audio) async {
    await audioPlayer.open(Audio(audio), autoStart: false);
  }

  Widget circularAudioPlayer(RealtimePlayingInfos rtpi, double ScreenWidth) {
    Color primaryColor = Colors.white;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 80),
        CircularPercentIndicator(
          radius: ScreenWidth / 2.2,
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
        appBar: AppBar(
          leading: CloseButton(
            onPressed: () {
              audioPlayer.stop();
              // Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => new MindfulCompletion()),
              // );
              // Navigator.of(context, rootNavigator: true)
              //     .pushReplacementNamed('/mindful_completion');
              Navigator.pushReplacementNamed(context, '/mindful_completion');
            },
          ),
          backgroundColor: Color(0xFFF6C344),
          centerTitle: true,
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(this.image), fit: BoxFit.cover)),
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
