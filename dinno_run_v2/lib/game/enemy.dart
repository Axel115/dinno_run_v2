import 'dart:math';
import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/cupertino.dart';

import 'constants.dart';

enum EnemyType { AngriPig, Bat, Rino }

class EnemyData {
  final String imageName;
  final int textureWidth;
  final int textureHeight;
  final int nColumns;
  final int nRows;
  final bool canFly;
  final int speed;

  const EnemyData({
    @required this.imageName,
    @required this.textureWidth,
    @required this.textureHeight,
    @required this.nColumns,
    @required this.nRows,
    @required this.canFly,
    @required this.speed,
  });
}

class Enemy extends AnimationComponent {
  EnemyData _myData;
  static Random _random = Random();

  static const Map<EnemyType, EnemyData> _enemyDatails = {
    EnemyType.AngriPig: EnemyData(
      imageName: 'AngryPig/Walk (36x30).png',
      nColumns: 16,
      nRows: 1,
      textureHeight: 30,
      textureWidth: 36,
      canFly: false,
      speed: 250,
    ),
    EnemyType.Bat: EnemyData(
      imageName: 'Bat/Flying (46x30).png',
      nColumns: 7,
      nRows: 1,
      textureHeight: 30,
      textureWidth: 46,
      canFly: true,
      speed: 300,
    ),
    EnemyType.Rino: EnemyData(
      imageName: 'Rino/Run (52x34).png',
      nColumns: 6,
      nRows: 1,
      textureHeight: 34,
      textureWidth: 52,
      canFly: false,
      speed: 350,
    )
  };

  Enemy(EnemyType enemyType) : super.empty() {
    _myData = _enemyDatails[enemyType];

    final spriteSheet = SpriteSheet(
      imageName: _myData.imageName,
      textureWidth: _myData.textureWidth,
      textureHeight: _myData.textureHeight,
      columns: _myData.nColumns,
      rows: _myData.nRows,
    );

    this.animation = spriteSheet.createAnimation(0,
        from: 0, to: (_myData.nColumns - 1), stepTime: 0.1);
    this.anchor = Anchor.center;
  }

  @override
  void resize(Size size) {
    super.resize(size);

    double scaleFactor =
        (size.width / numberOfTilesAlongWidth) / _myData.textureWidth;

    this.height = this.width = size.width / numberOfTilesAlongWidth;
    this.width = _myData.textureWidth * scaleFactor;
    this.x = size.width + this.width;

    // Esto mueve al dino a su posición
    this.y = size.height - groundHeight - (this.height / 2);

    if (_myData.canFly && _random.nextBool()) {
      this.y -= this.height;
    }
  }

  @override
  void update(double t) {
    super.update(t);
    this.x -= _myData.speed * t;
  }

  //para que los enemigos no se junten y no salgan uno seguido del otro
  @override
  bool destroy() {
    return (this.x < (-this.width));
  }
}
