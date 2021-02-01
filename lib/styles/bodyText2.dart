import 'package:digimobile/utils/constants.dart';
import 'package:flutter/material.dart';

class BodyText2 extends StatelessWidget {
  BodyText2({@required this.text, this.colour = white});

  final String text;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? 'Loading',
      style: Theme.of(context).textTheme.bodyText2.copyWith(color: colour),
    );
  }
}
