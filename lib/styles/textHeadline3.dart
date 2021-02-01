import 'package:digimobile/utils/constants.dart';
import 'package:flutter/material.dart';

class TextHeadline3 extends StatelessWidget {
  TextHeadline3({@required this.text, this.colour = primaryDarkMain});

  final String text;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? 'Loading',
      style: Theme.of(context).textTheme.headline3.copyWith(color: colour),
    );
  }
}
