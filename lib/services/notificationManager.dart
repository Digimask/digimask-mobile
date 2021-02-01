import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {

  // Singleton
  NotificationManager._();
  static final NotificationManager nm = NotificationManager._();

  // Notification config
  static final Map<String,Map<String,String>> _notificationConfigurations = {
    'maskSoonExpiredIn15Minutes':{
      'channelID':'1',
      'channelName':'Masque bientôt expiré',
      'channelDescription':'Masque bientôt expiré',
      'notificationTitle':'Votre masque est à changer bientôt !',
      'notificationBody':"Votre masque ne sera plus utilisable dans 15 minutes.",
    },
    'maskExpired':{
      'channelID':'1',
      'channelName':'Masque expiré',
      'channelDescription':'Masque expiré',
      'notificationTitle':'Votre masque est à changer au plus vite !',
      'notificationBody':"Votre masque n'est plus utilisable et doit être changé.",
    },
    'maskReusableExpired':{
      'channelID':'1',
      'channelName':'Masque à laver',
      'channelDescription':'Masque à laver',
      'notificationTitle':'Votre masque est à changer au plus vite !',
      'notificationBody':"Votre masque n'est plus utilisable et doit être lavé.",
    },
  };

  // Internal variables
  bool _initialized = false;

  initialize() async {

    if (!_initialized){

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin.
      resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: false,
      );

      final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
      final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      final InitializationSettings initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);

      await flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
      );

      _initialized = true;
    }
  }

  notifySoonExpired({String payload = ''}){
    _notify('maskSoonExpiredIn15Minutes', payload: payload);
  }

  notifyExpired({String payload = ''}){
    _notify('maskExpired', payload: payload);
  }

  notifyReusableExpired({String payload = ''}){
    _notify('maskReusableExpired', payload: payload);
  }

  _notify(String notificationName, {String payload = ''}) async {
    final Map<String,String> notificationConfiguration = _notificationConfigurations[notificationName];

    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        notificationConfiguration['channelID'],
        notificationConfiguration['channelName'],
        notificationConfiguration['channelDescription'],
        importance: Importance.max, priority: Priority.high, showWhen: false);
    IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics
    );

    await FlutterLocalNotificationsPlugin().show(
        0,
        notificationConfiguration['notificationTitle'],
        notificationConfiguration['notificationBody'],
        platformChannelSpecifics,
        payload: payload);
  }
}