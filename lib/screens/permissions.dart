import 'package:animations/animations.dart';
import 'package:digimobile/components/common_layouts.dart';
import 'package:digimobile/styles/textHeadline6.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionsPage extends StatefulWidget {
  @override
  _PermissionsPageState createState() {
    return _PermissionsPageState();
  }
}

class _PermissionsPageState extends State<PermissionsPage> with WidgetsBindingObserver, SingleTickerProviderStateMixin {

  // Display controllers
  AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      value: 0.0,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 200),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fadeController.forward();
    });
  }

  int _currentStep = 0;
  List<StepState> _stepStates = [
    StepState.editing,
    StepState.indexed,
    StepState.indexed,
    StepState.indexed,
    StepState.indexed,
  ];
  List<bool> _stepActive = [
    true,
    false,
    false,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {


    List<Step> steps = [
      Step(
        title: const Text('Explications'),
        isActive: _stepActive[0],
        state: _stepStates[0],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextHeadline6(text: "Merci d'avoir téléchargé l'application Digimask !"),
            SizedBox(height: 20),
            Text("Pour votre première utilisation, nous allons vous demander quelques permissions sur votre téléphone afin que l'application puisse fonctionner correctement et que vous puissiez en profiter pleinement.", textAlign: TextAlign.left, softWrap: true),
            SizedBox(height: 20),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: BorderSide(color: Theme.of(context).accentColor)),
              padding: EdgeInsets.all(8.0),
              onPressed: () {
                next();
              },
              child: Text("Commençons !",
                  style: Theme.of(context).textTheme.bodyText1),
            ),
          ],
        ),
      ),
      Step(
        title: const Text('Caméra'),
        isActive: _stepActive[1],
        state: _stepStates[1],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextHeadline6(text: "Permission d'accéder à la caméra"),
            SizedBox(height: 20),
            Text("Nous avons besoin d'utiliser votre caméra afin de scanner les QR codes sur vos masques afin de les connecter à l'application.", textAlign: TextAlign.left, softWrap: true),
            SizedBox(height: 20),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: BorderSide(color: Theme.of(context).accentColor)),
              padding: EdgeInsets.all(8.0),
              onPressed: () async {
                if (await Permission.camera.request().isGranted) {
                  next();
                }
              },
              child: Text("Demander la permission",
                  style: Theme.of(context).textTheme.bodyText1),
            ),
          ],
        ),
      ),
      Step(
        title: const Text('GPS'),
        isActive: _stepActive[2],
        state: _stepStates[2],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextHeadline6(text: "Permission d'accéder au GPS"),
            SizedBox(height: 20),
            Text("Nous avons besoin d'utiliser votre GPS afin de vous donner les informations épidémiologiques de votre département.", textAlign: TextAlign.left, softWrap: true),
            SizedBox(height: 20),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: BorderSide(color: Theme.of(context).accentColor)),
              padding: EdgeInsets.all(8.0),
              onPressed: () async {
                if (await Permission.location.request().isGranted) {
                  next();
                }
              },
              child: Text("Demander la permission",
                  style: Theme.of(context).textTheme.bodyText1),
            ),
          ],
        ),
      ),
      Step(
        title: const Text('Notifications'),
        isActive: _stepActive[3],
        state: _stepStates[3],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextHeadline6(text: "Permission d'afficher des notifications"),
            SizedBox(height: 20),
            Text("Nous avons besoin de vous afficher des notifications notamment pour vous avertir lorsque votre masque n'est plus utilisable", textAlign: TextAlign.left, softWrap: true),
            SizedBox(height: 20),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: BorderSide(color: Theme.of(context).accentColor)),
              padding: EdgeInsets.all(8.0),
              onPressed: () async {
                if (await Permission.notification.request().isGranted) {
                  next();
                }
              },
              child: Text("Demander la permission",
                  style: Theme.of(context).textTheme.bodyText1),
            ),
          ],
        ),
      ),
      Step(
        title: const Text('Fini !'),
        isActive: _stepActive[4],
        state: _stepStates[4],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextHeadline6(text: "Terminé !"),
            SizedBox(height: 20),
            Text("C'était rapide hein ? Maintenant vous allez pouvoir utiliser pleinement votre application Digimask !", textAlign: TextAlign.left, softWrap: true),
            SizedBox(height: 20),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: BorderSide(color: Theme.of(context).accentColor)),
              padding: EdgeInsets.all(8.0),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('done', true);
                next();
              },
              child: Text("C'est parti !",
                  style: Theme.of(context).textTheme.bodyText1),
            ),
          ],
        ),
      ),
    ];

    Widget _createEventControlBuilder(BuildContext context,
        {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
      return SizedBox.shrink();
    }

    return FadeScaleTransition(
      animation: _fadeController,
      child: Column(
        children: [
          SizedBox(height: 40),
          ScreenLayouts.topPageTitle(context, "Digimask"),
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              type: StepperType.vertical,
              controlsBuilder: _createEventControlBuilder,
              steps: steps,
            ),
          ),
        ],
      )
    );
  }

  goTo(int step) {
    setState((){
      _currentStep = step;
      _stepActive[step] = true;
      _stepStates[step] = StepState.editing;
      _stepActive[step-1] = false;
      _stepStates[step-1] = StepState.complete;
    });
  }

  next() {
    _currentStep + 1 != 5
        ? goTo(_currentStep + 1)
        : Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);;
  }
}