import 'package:digimobile/utils/constants.dart';
import 'package:flutter/material.dart';

class TextHeadline4 extends StatelessWidget {
  TextHeadline4({@required this.text, this.colour = white});

  final String text;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? 'Loading',
      style: Theme.of(context).textTheme.headline4.copyWith(color: colour),
    );
  }
}
