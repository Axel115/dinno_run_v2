import 'package:dinno_run_v2/game/audio_manager.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/animation.dart' as flameAnimation;
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:flame/time.dart';
import 'package:flutter/cupertino.dart';

import 'constants.dart';

class Dino extends AnimationComponent {
  flameAnimation.Animation _runAnimation;
  flameAnimation.Animation _hitAnimation;
  Timer _timer;
  bool _isHit;

  double speedY = 0.0;
  double yMax = 0.1;

  ValueNotifier<int> life;

  Dino() : super.empty() {
    final spriteSheet = SpriteSheet(
      imageName: 'DinoSprites - tard.png',
      textureWidth: 24,
      textureHeight: 24,
      columns: 24,
      rows: 1,
    );

    _runAnimation =
        spriteSheet.createAnimation(0, from: 4, to: 10, stepTime: 0.1);
    _hitAnimation =
        spriteSheet.createAnimation(0, from: 14, to: 16, stepTime: 0.1);

    this.animation = _runAnimation;
    // El tiempo que va a durar la animación de cuando te haces daño por algún enemigo
    _timer = Timer(1, callback: () {
      run();
    });
    _isHit = false;

    this.anchor = Anchor.center;

    life = ValueNotifier(5);
  }

  @override
  void resize(Size size) {
    super.resize(size);

    this.height = this.width = size.width / numberOfTilesAlongWidth;
    this.x = this.width;

    // Esto mueve al dino a su posición
    this.y =
        size.height - groundHeight - (this.height / 2) + dinoTopBottomSpacing;
    this.yMax = this.y;
  }

  @override
  void update(double t) {
    super.update(t);

    this.speedY += GRAVITY * t;

    this.y += this.speedY * t;

    if (isOnGround()) {
      this.y = this.yMax;
      this.speedY = 0.0;
    }

    _timer.update(t);
  }

  bool isOnGround() {
    return (this.y >= this.yMax);
  }

  void run() {
    _isHit = false;
    this.animation = _runAnimation;
  }

  void hit() {
    if (!_isHit) {
      this.animation = _hitAnimation;
      _timer.start();
      _isHit = true;
      life.value -= 1;

      AudioManager.instance.playSfx('hurt7.wav');
    }
  }

  void jump() {
    if (isOnGround()) {
      this.speedY = -500;
      AudioManager.instance.playSfx('jump14.wav');
    }
  }
}
