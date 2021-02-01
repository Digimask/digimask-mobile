import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:digimobile/components/card_elements/reusable_card.dart';
import 'package:digimobile/components/card_elements/round_icon_button.dart';
import 'package:digimobile/components/common_layouts.dart';
import 'package:digimobile/countdown/countdown.dart';
import 'package:digimobile/countdown/countdown_controller.dart';
import 'package:digimobile/models/mask_model.dart';
import 'package:digimobile/services/db_service.dart';
import 'package:digimobile/services/notificationManager.dart';
import 'package:digimobile/styles/textHeadline5.dart';
import 'package:digimobile/styles/textHeadline6.dart';
import 'package:digimobile/utils/toolbox.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:majascan/majascan.dart';

class MaskPage extends StatefulWidget {
  @override
  _MaskPageState createState() {
    return _MaskPageState();
  }
}

class _MaskPageState extends State<MaskPage> with WidgetsBindingObserver, SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin  {

  // Data
  Mask _mask;
  Duration _listenerDuration;

  // Display
  bool _isLoading = true;
  bool _maskLoaded = false;

  // Display controllers
  AnimationController _fadeController;
  CountdownController _countdownController;

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
      await _load();
      _fadeController.forward();
    });
  }

  _load() async {
    setState(() {
      _isLoading = false;
      _maskLoaded = false;
    });
  }

  _scan() async {
    String qrResult = await MajaScan.startScan(
        title: 'Digimask',
        barColor: Theme.of(context).backgroundColor,
        titleColor: Colors.white,
        qRCornerColor: Theme.of(context).accentColor,
        qRScannerColor: Theme.of(context).accentColor,
        flashlightEnable: true,
        scanAreaScale: 0.7
    );

    var qrContent = json.decode(qrResult);
    if (qrContent["maskID"] == null){
      // QR code is not designed to be interpreted by the app, error
      EasyLoading.showError("Le QR code scanné n'est pas conforme, veuillez le rescanner ou en utiliser un autre.", duration: Duration(seconds: 2));
    } else {
      // QR code is designed to be interpreted by the app, process
      final Mask maskFromQR = Mask(qrContent);
      final Mask maskFromDB = await DBService.db.retrieveMaskSpecific(maskFromQR.getID().toString());
      if (maskFromDB != null){
        _mask = maskFromDB;
      } else {
        _mask = maskFromQR;
        _mask.insert();
      }

      _maskLoaded = false;
      if (_mask.isSurgical){
        if (!(_mask.remainingTime.inSeconds == 0)){
          _maskLoaded = true;
        }
      } else if (_mask.isReusable){
        if (_mask.remainingTime.inSeconds == 0){
          if (_mask.currentWashingCounter < _mask.maxWashingCounter){
            _mask.incrementWashingCounter();
            _maskLoaded = true;
          }
        } else {
          _maskLoaded = true;
        }
      }
      if (_maskLoaded == false){
        EasyLoading.showError('Votre masque est expiré, veuillez en utiliser un autre.', duration: Duration(seconds: 5), dismissOnTap: true);
      } else {
        EasyLoading.showInfo('Chargement des données de votre masque', duration: Duration(seconds: 1));
        setState(() {
          _countdownController = CountdownController(duration: _mask.remainingTime);
          _countdownController.addListener(() {
            _listenerDuration = Toolbox.convertCurrentRemainingTimeToDuration(_countdownController.currentRemainingTime);
            if (_listenerDuration.inSeconds == 900){
              NotificationManager.nm.notifySoonExpired();
            } else if (_listenerDuration.inSeconds == 0) {
              if ((_mask.isReusable) && (_mask.currentWashingCounter < _mask.maxWashingCounter)){
                NotificationManager.nm.notifyReusableExpired();
              } else {
                NotificationManager.nm.notifyExpired();
              }
              _mask.updateRemainingTime(Toolbox.convertCurrentRemainingTimeToDuration(_countdownController.currentRemainingTime));
              _mask.update();
            }
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget _cardWashingCounter(){
      return Expanded(
        child: ReusableCard(
          colour: Theme.of(context).cardColor,
          cardChild: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextHeadline6(text: 'Nombre de lavages'),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RoundIconButton(
                    icon: FontAwesomeIcons.minus,
                    onPressed: () async {
                      await _mask.decrementWashingCounter();
                      setState(() {

                      });
                    },
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  TextHeadline5(text: "${_mask.currentWashingCounter} / ${_mask.maxWashingCounter}"),
                  SizedBox(
                    width: 20.0,
                  ),
                  RoundIconButton(
                    icon: FontAwesomeIcons.plus,
                    onPressed: () async {
                      await _mask.incrementWashingCounter();
                      setState(() {
                        _countdownController = CountdownController(duration: _mask.remainingTime);
                      });
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget _maskInfosContainer(){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ReusableCard(
              colour: Theme.of(context).cardColor,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextHeadline6(text: 'Type de masque'),
                  TextHeadline5(text: _mask.isSurgical ? "Chirurgical" : "Réutilisable"),
                ],
              ),
            ),
          ),
          Expanded(
            child: ReusableCard(
              colour: Theme.of(context).cardColor,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextHeadline6(text: 'Temps restant'),
                  Countdown(
                    countdownController: _countdownController,
                    builder: (_, Duration time) {
                      if (time == null) {
                        return TextHeadline5(text: 'Masque périme !');
                      } else {
                        if (time.inSeconds == 0) {
                          WidgetsBinding.instance.addPostFrameCallback((_) async {
                            await _fadeController.reverse();
                            await _load();
                            _fadeController.forward();
                          });
                          EasyLoading.showInfo("La durée d'utilisation de votre masque vient d'expirer, changez le !", duration: Duration(seconds: 30), dismissOnTap: true);
                          return TextHeadline5(text: 'Masque périme !');
                        } else {
                          return TextHeadline5(text: Toolbox.convertDurationToDisplay(time));
                        }
                      }
                    },
                  ),
                  SizedBox(height: 10.0,),
                  GestureDetector(
                      onTap: () async {
                        if (_countdownController.isRunning){
                          _countdownController.stop();
                          _mask.updateRemainingTime(Toolbox.convertCurrentRemainingTimeToDuration(_countdownController.currentRemainingTime));
                          _mask.update();
                        } else {
                          _countdownController.start();
                        }
                        setState(() {

                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        margin: EdgeInsets.symmetric(
                          horizontal: 30
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(_countdownController.isRunning ? Icons.stop : Icons.play_arrow, color: Theme.of(context).accentColor, size: 30,),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(_countdownController.isRunning ? "Stopper le compteur" : "Lancer le compteur", style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).accentColor), textAlign: TextAlign.center),
                          ],
                        ),
                      )
                  ),
                ],
              ),
            ),
          ),
          _mask.isReusable ? _cardWashingCounter() : Container(),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              _countdownController.stop();
              _mask.updateRemainingTime(Toolbox.convertCurrentRemainingTimeToDuration(_countdownController.currentRemainingTime));
              _mask.update();
              await _fadeController.reverse();
              setState(() {
                _mask = null;
                _maskLoaded = false;
              });
              _fadeController.forward();
            },
            child: Text("Changer de masque", style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).accentColor), textAlign: TextAlign.center),
          ),
          SizedBox(height: 20),
        ],
      );
    }

    Widget _maskScanContainer(){
      return Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Container(
          margin: EdgeInsets.all(30),
          child: Column(
            children: [
              Flexible(
                  child: Text("Commencez par scanner le QR code présent sur votre masque", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6,)
              ),
              Container(
                height: 300,
                width: 300,
                child: FlareActor("assets/animations/barcode.flr", alignment:Alignment.center, fit: BoxFit.contain, animation: 'scan'),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    side: BorderSide(color: Theme.of(context).accentColor)),
                padding: EdgeInsets.all(8.0),
                onPressed: _scan,
                child: Text("Démarrer le scan",
                    style: Theme.of(context).textTheme.headline6),
              ),
            ],
          ),
        ),
      );
    }

    Widget _bodyContainer(){
      return Expanded(
          child: _maskLoaded ? _maskInfosContainer() : _maskScanContainer()
      );
    }

    return FadeScaleTransition(
      animation: _fadeController,
      child: _isLoading ?
      ScreenLayouts.loadingWithDescription("Chargement du module masque") :
      Column(
          children: [
            ScreenLayouts.topPageTitle(context, 'Mon masque'),
            _bodyContainer(),
          ]
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}