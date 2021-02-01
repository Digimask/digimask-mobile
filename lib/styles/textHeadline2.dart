import 'package:digimobile/utils/constants.dart';
import 'package:flutter/material.dart';

class TextHeadline2 extends StatelessWidget {
  TextHeadline2({@required this.text, this.colour = white});

  final String text;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? 'Loading',
      style: Theme.of(context).textTheme.headline2.copyWith(color: colour),
    );
  }
}
