import 'package:digimobile/components/color_loader_4.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ScreenLayouts {

  static Widget appBar(BuildContext context){

    IconButton _settings(){
      return IconButton(
          icon: Icon(Icons.settings, color: Theme.of(context).iconTheme.color),
          onPressed: () {
          }
      );
    }

    return AppBar(
      title: Text("Digimask", style: Theme.of(context).textTheme.headline5),
      elevation: 0,
      backgroundColor: Theme.of(context).canvasColor,
    );
  }

  static Widget topPageTitle(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(title,
          style: Theme.of(context).textTheme.headline5),
    );
  }

  static Widget centerText(BuildContext context, String text) {
    return Center(
      child: Text(
        text,
        style: Theme.of(context).textTheme.subtitle1.copyWith(fontStyle: FontStyle.italic),
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget loading(){
    return FlareActor("assets/animations/loading.flr", alignment:Alignment.center, fit:BoxFit.contain, animation: 'Alarm');
  }

  static Widget loadingWithDescription(String title){
    return Center(
      child: Container(
        alignment: Alignment(0.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title),
            SizedBox(height: 20),
            ColorLoader4(dotOneColor: Colors.cyan, dotTwoColor: Colors.amber, dotThreeColor: Colors.red, dotType: DotType.circle)
          ],
        ),
      ),
    );
  }
}