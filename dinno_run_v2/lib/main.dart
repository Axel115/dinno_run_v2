import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:dinno_run_v2/screens/main_menu.dart';
import 'package:flame/game/base_game.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'game/audio_manager.dart';
import 'game/game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.util.fullScreen();
  await Flame.util.setLandscape();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  AudioManager.instance
      .init(['8BitPlatformerLoop.wav', 'hurt7.wav', 'jump14.wav']);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dino Run',
      theme: ThemeData(
        fontFamily: 'Audiowide',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainMenu(),
    );
  }
}
