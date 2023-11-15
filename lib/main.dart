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
  StreamSubscription<Duration?>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  Duration? _duration;
  Duration? _position;
  bool _isLoading = false;

  @override
  void dispose() {
    _player.dispose();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    super.dispose();
  }

  void playMusic() async {
    print('playMusic called');
    _isLoading = true;
    var url = 'http://localhost:8080/beepstream';
    await _player.setUrl(url);
    _player.play();
    _isLoading = false;

    _positionSubscription = _player.positionStream.listen((position) {
      _position = position;
      _checkAudioProgress();
    });

    _durationSubscription = _player.durationStream.listen((duration) {
      _duration = duration;
      _checkAudioProgress();
    });
  }

  void _checkAudioProgress() async {
    if (_position != null && _duration != null) {
      double progress = _position!.inMilliseconds / _duration!.inMilliseconds;
      if (progress >= 0.75) {
        // If the audio is 75% complete and the player is not already loading the next audio
        if (!_isLoading) {
          playMusic(); // Request more data here
        }
      }
    }
  }

  void stopMusic() {
    _player.stop();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
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
