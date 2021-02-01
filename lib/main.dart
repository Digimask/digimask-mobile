import 'package:digimobile/screens/home.dart';
import 'package:digimobile/screens/permissions.dart';
import 'package:digimobile/services/notificationManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/common_layouts.dart';

void main() => runApp(Digimask());

class Digimask extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digimask',
      theme: ThemeData.dark(),
      home: MainPage(),
      builder: EasyLoading.init(),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        final arguments = settings.arguments;
        switch (settings.name) {
          case '/': return MaterialPageRoute(builder: (context) => MainPage());
          case '/home': return MaterialPageRoute(builder: (context) => HomePage());
          case '/permissions': return MaterialPageRoute(builder: (context) => PermissionsPage());
          default: return MaterialPageRoute(builder: (context) => HomePage());
        }
      },
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () async {
      await _checkPermissions();
    });
  }

  // Loading screen during process //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenLayouts.loadingWithDescription("Lancement de l'application"),
    );
  }

  // Local methods
  _checkPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool permissions = prefs.getBool('done');
    if (permissions != true){
      Navigator.pushNamedAndRemoveUntil(context, '/permissions', (Route<dynamic> route) => false);
    } else {
      NotificationManager.nm.initialize();
      Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
    }
  }
}
