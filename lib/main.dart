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

  Song({required this.title, required this.artist, required this.path});
}

final List<Song> songs = [
  Song(title: "Song 1", artist: "Artist 1", path: "assets/song1.mp3"),
  Song(title: "Song 2", artist: "Artist 2", path: "assets/song2.mp3")
];


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vinyl: A Personal Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlaylistScreen(),
    );
  }
}

class PlaylistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Your Playlist')),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index){
          return ListTile(
            leading: Icon(Icons.music_note),
            title: Text(songs[index].title),
            subtitle: Text(songs[index].artist),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicPlayerScreen(song: songs[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MusicPlayerScreen extends StatelessWidget {
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/album_art.jpg'),
          SizedBox(height: 20),
          Text(
            'Song Title',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('Artist Name'),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.skip_previous),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () {
                  audioPlayer.play('assets/song1.mp3');
                },
              ),
            ],
          ),
        ],
      ),

    );
  }

  class MusicPlayerScreen extends StatefulWidget {
  final Song song;
  const MusicPlayerScreen({Key? key, required this.song}) : super(key: key);

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
  }

  class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double progress = 0.0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  bool isShuffling = false;
  bool isRepeating = false;

  @override
  void initState() {
  super.initState();

  // Load audio
  audioPlayer.setSource(AssetSource(widget.song.path));

  // Listen to duration
  audioPlayer.onDurationChanged.listen((d) {
  setState(() => duration = d);
  });

  // Listen to position
  audioPlayer.onPositionChanged.listen((p) {
  setState(() => position = p);
  });
  }

  @override
  void dispose() {
  audioPlayer.dispose();
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(title: Text(widget.song.title)),
  body: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  Text(widget.song.artist, style: const TextStyle(fontSize: 18)),

  // Slider for progress
  Slider(
  value: position.inSeconds.toDouble(),
  min: 0.0,
  max: duration.inSeconds.toDouble(),
  onChanged: (value) {
  audioPlayer.seek(Duration(seconds: value.toInt()));
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

  IconButton(
  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 50),
  onPressed: () async {
  if (isPlaying) {
  await audioPlayer.pause();
  } else {
  await audioPlayer.resume();
  }
  setState(() => isPlaying = !isPlaying);
  },
  ),

  // Player controls
  Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  IconButton(
  icon: Icon(Icons.shuffle,
  color: isShuffling ? Colors.blue : null),
  onPressed: () {
  setState(() => isShuffling = !isShuffling);
  },
  ),
  IconButton(
  icon: const Icon(Icons.skip_previous),
  onPressed: () {
  },
  ),
  IconButton(
  icon: const Icon(Icons.play_arrow),
  onPressed: () {
  },
  ),
  IconButton(
  icon: const Icon(Icons.skip_next),
  onPressed: () {
  // implement skip next
  },
  ),
  IconButton(
  icon: Icon(Icons.repeat,
  color: isRepeating ? Colors.blue : null),
  onPressed: () {
  setState(() => isRepeating = !isRepeating);
  },
  ),
  ],
  )
  ],
  ),
  );
  }

  String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return "$minutes:$seconds";
  }
  }
  class PlaylistScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
  return Scaffold(
  appBar: AppBar(
  title: Text('Playlist'),
  ),
  body: ListView.builder(
  itemCount: songs.length,
  itemBuilder: (context, index){
  return ListTile(
  title: Text(songs[index].title),
  subtitle: Text(songs[index].artist),
  onTap: () {
  Navigator.push(
  context,
  MaterialPageRoute(
  builder: (context) => MusicPlayerScreen(song: songs[index]),
  ),
  );
  },
  );
  },
  ),
  );
  }
  }




