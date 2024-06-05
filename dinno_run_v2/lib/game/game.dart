import 'package:dinno_run_v2/game/audio_manager.dart';
import 'package:dinno_run_v2/game/dino.dart';
import 'package:dinno_run_v2/game/enemy.dart';
import 'package:dinno_run_v2/widgetds/pause_menu.dart';
import 'package:dinno_run_v2/game/enemy_manager.dart';
import 'package:flame/components/parallax_component.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/game.dart';
import 'package:flame/game/base_game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dinno_run_v2/widgetds/game_over_manu.dart';
import 'package:dinno_run_v2/widgetds/hud.dart';

class DinoGame extends BaseGame with TapDetector, HasWidgetsOverlay {
  // Movimiento del dino y del fondo
  Dino _dino;
  ParallaxComponent _parallaxComponent;
  TextComponent _scoreText;
  double _elapsedTime = 0.0;
  int score;
  EnemyManager _enemyManager;

  bool _isGameOver = false;
  bool _isGamePaused = false;

  DinoGame() {
    // Inicialización del parallax
    _parallaxComponent = ParallaxComponent(
      [
        ParallaxImage('parallax/plx-1.png'),
        ParallaxImage('parallax/plx-2.png'),
        ParallaxImage('parallax/plx-3.png'),
        ParallaxImage('parallax/plx-4.png'),
        ParallaxImage('parallax/plx-5.png'),
        ParallaxImage('parallax/plx-6.png', fill: LayerFill.none),
      ],
      baseSpeed: Offset(100, 0),
      layerDelta: Offset(20, 0),
    );
    add(_parallaxComponent);

    // Inicialización del dino
    _dino = Dino();
    add(_dino);

    _enemyManager = EnemyManager();
    add(_enemyManager);

    score = 0;
    _scoreText = TextComponent(
      score.toString(),
      config: TextConfig(fontFamily: 'Audiowide', color: Colors.white),
    );
    add(_scoreText);

    addWidgetOverlay(
      'Hud',
      HUD(
        life: _dino.life,
        onPausePressed: pauseGame,
      ),
    );

    AudioManager.instance.startBgm('8BitPlatformerLoop.wav');
  }

  get onPressed => null;

  @override
  void resize(Size size) {
    super.resize(size);
    _scoreText
        .setByPosition(Position(((size.width / 2) - (_scoreText.width)), 0));
  }

  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
    if (!_isGameOver) {
      _dino.jump();
    }
  }

  @override
  void update(double t) {
    super.update(t);
    _elapsedTime += t;
    if (_elapsedTime > (1 / 60)) {
      _elapsedTime = 0.0;
      score += 1;
      _scoreText.text = score.toString();
    }

    components.whereType<Enemy>().forEach((enemy) {
      if (_dino.distance(enemy) < 30) {
        _dino.hit();
      }
    });

    if (_dino.life.value <= 0) {
      gameOver();
    }
  }

  @override
  void lifecyleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;

      case AppLifecycleState.resumed:
        this.pauseGame();
        break;

      case AppLifecycleState.resumed:
        this.pauseGame();
        break;

      case AppLifecycleState.resumed:
        this.pauseGame();
        break;
    }
  }

  void pauseGame() {
    pauseEngine();

    _isGamePaused = true;

    if(!_isGameOver){
      addWidgetOverlay(
        'PauseMenu',
        PauseMenu(
          onResumePressed: resumeGame,
        ));
    }

    
    AudioManager.instance.pauseBgm();
  }

  void resumeGame() {
    removeWidgetOverlay('PauseMenu');

    _isGameOver = false;

    resumeEngine();
    AudioManager.instance.resumeBgm();
  }

  void gameOver() {
    pauseEngine();

    _isGameOver = true;

    addWidgetOverlay(
        'GameOverMenu',
        GameOverMenu(
          score: score,
          onRestartPressed: reset,
        ));
  }

  void reset() {
    this.score = 0;
    _dino.life.value = 5;
    _dino.run();
    _enemyManager.reset();

    components.whereType<Enemy>().forEach((enemy) {
      this.markToRemove(enemy);
    });

    removeWidgetOverlay('GameOverMenu');
    _isGameOver = false;
    resumeEngine();
    AudioManager.instance.resumeBgm();
  }

  @override
  void onDetach() {
    AudioManager.instance.stopBgm();
    super.onDetach();
  }
}
