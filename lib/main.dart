import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: MusicPlayer(),
        ),
      ),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final _player = AudioPlayer();
  Timer? _timer;

  @override
  void dispose() {
    _player.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void playMusic() async {
    var url = 'http://localhost:8080';
    await _player.setUrl(url);
    _player.play();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await _player.setUrl(url);
      _player.play();
    });
  }

  void stopMusic() {
    _player.stop();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: Text('Play'),
          onPressed: playMusic,
        ),
        ElevatedButton(
          child: Text('Stop'),
          onPressed: stopMusic,
        ),
      ],
    );
  }
}
