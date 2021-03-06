import 'package:digimobile/utils/constants.dart';
import 'package:flutter/material.dart';

class BodyText1Ellipsis extends StatelessWidget {
  BodyText1Ellipsis({@required this.text, this.colour = white});

  final String text;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? 'Loading',
      style: Theme.of(context).textTheme.bodyText1.copyWith(color: colour),
      overflow: TextOverflow.ellipsis,
    );
  }
}
