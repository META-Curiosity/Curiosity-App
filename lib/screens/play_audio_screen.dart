import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:percent_indicator/percent_indicator.dart';
import './mindful_completion_screen.dart';
import 'dart:math';

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
  String _id = '';
  @override
  void didChangeDependencies() {
    final arg = ModalRoute.of(context).settings.arguments as List;
    String uuid = arg[0];
    int args = arg[1];
    setState(() {
      _id = uuid;
    });
    Random random = new Random();
    //Set the image and audio based on the setting selected.
    if (args == 0) {
      //Picks a random number in range [0,2]
      int randomNumber = random.nextInt(5);
      List<String> audioChoices = [
        'assets/audio/eating1.mp3',
        'assets/audio/eating2.mp3',
        'assets/audio/eating3.mp3',
        'assets/audio/eating4.mp3',
        'assets/audio/eating5.mp3'
      ];

      image = 'assets/images/food.jpg';
      audio = audioChoices[randomNumber];
      print("0");
      print(audio);
    } else if (args == 1) {
      int randomNumber = random.nextInt(3);
      List<String> audioChoices = [
        'assets/audio/walking1.mp3',
        'assets/audio/walking2.mp3',
        'assets/audio/walking3.mp3'
      ];

      image = 'assets/images/forest.jpeg';
      audio = audioChoices[randomNumber];
      print("1");
      print(audio);
    } else {
      //Picks a random number in range [0,2]
      int randomNumber = random.nextInt(3);
      List<String> audioChoices = [
        'assets/audio/washing1.mp3',
        'assets/audio/washing2.mp3',
        'assets/audio/washing3.mp3'
      ];

      image = 'assets/images/beach.jpg';
      audio = audioChoices[randomNumber];
      print("2");
      print(audio);
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
              Navigator.pushReplacementNamed(context, '/mindful_completion',
                  arguments: _id);
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
