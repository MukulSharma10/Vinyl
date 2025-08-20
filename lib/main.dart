import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main(){
  runApp(MyApp());
}

class Song{
  final String title;
  final String artist;
  final String path;

  Song({required this.title, required this.artist, required this.path});
}

final List<Song> songs = [
Song(title: "Song 1", artist: "Artist 1", path: "assets/song1.mp3"),
];


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Vinyl: A Personal Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MusicPlayerScreen(),
    );
  }
}

class MusicPlayerScreen extends StatelessWidget{
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context){
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
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen>{
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: Column(
        children: [
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () {
            if(isPlaying){
              audioPlayer.pause();
              }else{
            audioPlayer.play('assets/song1.mp3');
              }
              setState(() {
                isPlaying = !isPlaying;
              });
            },
          ),
        ]
      ),
    );
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


