import 'package:flutter/material.dart';

class HUD extends StatelessWidget {
  final ValueNotifier<int> life;
  final VoidCallback onPausePressed;

  const HUD({
    Key key,
    @required this.life,
    @required this.onPausePressed,
  })  : assert(life != null),
        assert(onPausePressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ValueListenableBuilder<int>(
            valueListenable: life,
            builder: (context, value, child) {
              return Text(
                'Life: $value',
                style: TextStyle(fontSize: 24, color: Colors.white),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.pause, color: Colors.white),
            onPressed: onPausePressed,
          ),
        ],
      ),
    );
  }
}
