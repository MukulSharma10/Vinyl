import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class Song {
  final String title;
  final String artist;
  final String path;
  final String albumArt;

  Song({required this.title, required this.artist, required this.path, required this.albumArt});
}

final List<Song> songs = [
  Song(title: "Setting Fires", artist: "The Chainsmokers", path: "song1.mp3", albumArt: "assets/albumArt1.jpg"),
  Song(title: "All We Know", artist: "The Chainsmokers", path: "song2.mp3", albumArt: "assets/albumArt2.png"),
  Song(title: "Closer", artist: "The Chainsmokers", path: "song3.mp3", albumArt: "assets/albumArt3.jpg"),
  Song(title: "Inside Out", artist: "The Chainsmokers", path: "song4.mp3", albumArt: "assets/albumArt4.jpg"),
  Song(title: "Don't Let Me Down", artist: "The Chainsmokers", path: "song5.mp3", albumArt: "assets/albumArt5.jpg"),
];


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vinyl: A Personal Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MusicPlayerScreen(),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
  }

  class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  bool isShuffling = false;
  bool isRepeating = false;

  int currentIndex = 0;
  Song get currentSong => songs[currentIndex];

  @override
  void initState() {
    super.initState();
    _loadSong();

  _audioPlayer.onDurationChanged.listen((d) {
    setState(() => duration = d);
  });

  _audioPlayer.onPositionChanged.listen((p) {
  setState(() => position = p);
  });
  }


  Future<void> _loadSong() async{
    await _audioPlayer.setSource(AssetSource(currentSong.path));
  }

  @override
  void dispose() {
  _audioPlayer.dispose();
  super.dispose();
  }

  String formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(title:
  Text(currentSong.title,
  style: TextStyle(
    color: Colors.black,
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  ),)),
  body: Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(currentSong.albumArt),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.4),
          BlendMode.darken,
        ),
      ),
    ),

  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  Text(currentSong.artist, style: const TextStyle(fontSize: 18, color: Colors.white)),


  Slider(
  value: position.inSeconds.toDouble(),
  min: 0.0,
  max: duration.inSeconds.toDouble() > 0 ? duration.inSeconds.toDouble() : 1,
  onChanged: (value) {
  _audioPlayer.seek(Duration(seconds: value.toInt()));
  },
  ),

  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Text(formatTime(position)),
  Text(formatTime(duration - position)),
  ],
  ),
  ),

  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        icon: const Icon(Icons.skip_previous, size: 40),
        onPressed: (){
          setState(() {
            currentIndex = (currentIndex - 1 + songs.length) % songs.length;
          });
          _loadSong();
          _audioPlayer.resume();
          setState(() => isPlaying = true); },
      ),
      IconButton(
        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 60),
        onPressed: () async {
          if (isPlaying) {
            await _audioPlayer.pause();
          } else{
            await _audioPlayer.resume();
          }
          setState(() => isPlaying = !isPlaying);
          },
      ),
      IconButton(
        icon: const Icon(Icons.skip_next, size: 40),
        onPressed: () {
          setState(() {
            currentIndex = (currentIndex + 1) % songs.length;
          });
          _loadSong();
          _audioPlayer.resume();
          setState(() => isPlaying = true);
        },
      ),
    ],
  )
  ],
  ),
  ),
  );
  }
  }