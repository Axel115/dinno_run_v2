import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dinno_run_v2/screens/game_play.dart'; // Asegúrate de que la ruta es correcta

class Menu extends StatelessWidget {
  final VoidCallback onSettingsPressed;

  const Menu({
    Key key,
    @required this.onSettingsPressed,
  })  : assert(onSettingsPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Dino Run',
          style: TextStyle(fontSize: 60.0, color: Colors.white),
        ),
        RaisedButton(
          child: Text(
            'Play',
            style: TextStyle(fontSize: 30.0),
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => GamePlay(), // Asegúrate de definir GamePlayScreen
              ),
            );
          },
        ),
        RaisedButton(
          child: Text(
            'Settings',
            style: TextStyle(fontSize: 30.0),
          ),
          onPressed: onSettingsPressed,
        ),
      ],
    );
  }
}
