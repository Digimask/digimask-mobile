import 'package:animations/animations.dart';
import 'package:digimobile/components/card_elements/reusable_card.dart';
import 'package:digimobile/components/common_layouts.dart';
import 'package:digimobile/models/global_infos_model.dart';
import 'package:digimobile/models/infos_model.dart';
import 'package:digimobile/models/local_infos_model.dart.dart';
import 'package:digimobile/services/infos_service.dart';
import 'package:digimobile/styles/bodyText1.dart';
import 'package:digimobile/styles/textHeadline5.dart';
import 'package:digimobile/styles/textHeadline6.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class InfosPage extends StatefulWidget {
  @override
  _InfosPageState createState() {
    return _InfosPageState();
  }
}

class _InfosPageState extends State<InfosPage> with WidgetsBindingObserver, SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  GlobalInfosModel globalData;
  LocalInfosModel localData;
  InfosModel displayedData;

  // Display
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<bool> isSelected = [true, false];
  bool _isLoading = true;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: 0.0,
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _load();
    });
  }

  _load() async {
    setState(() {
      _isLoading = true;
    });

    globalData = await InfosService().getGlobalData();
    localData  = await InfosService().getLocalData();
    displayedData = globalData;

    _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {
        _isLoading = false;
        _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget _getToggleButton(){
      // Check if local data has been retrieved correctly
      if (localData != null){
        return Container(
          child: ToggleButtons(
            selectedColor: Colors.white,
            borderRadius: BorderRadius.circular(5),
            fillColor: Theme.of(context).toggleableActiveColor.withOpacity(0.50),
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: 20, right: 20,
                    bottom: 10, top: 10),
                child: BodyText1(text: 'National'),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: 20, right: 20,
                    bottom: 10, top: 10),
                child: BodyText1(text: localData.department),
              ),
            ],
            isSelected: isSelected,
            onPressed: (int index) {
              setState(() {
                for (int indexBtn = 0;indexBtn < isSelected.length;indexBtn++) {
                  if (indexBtn == index) {
                    isSelected[indexBtn] = true;
                  } else {
                    isSelected[indexBtn] = false;
                  }
                }
                displayedData = isSelected[0] == true ? globalData : localData;
              });
            },
          ),
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
        );
      } else {
        // No data, GPS must has been desactivated
        EasyLoading.showError('Le GPS est désactivé, seules les données nationales seront affichées', duration: Duration(seconds: 3), dismissOnTap: true);
        return Container(
          padding: EdgeInsets.all(20),
          child: TextHeadline6(text: "National"),
        );
      }
    }

    Widget _getBodyContent(){
      return Column(
          children: [
            ScreenLayouts.topPageTitle(context, 'Informations épidémiologiques'),
            _getToggleButton(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: ReusableCard(
                      colour: Theme.of(context).cardColor,
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextHeadline6(text: 'Hospitalisations'),
                          TextHeadline5(text: displayedData.hospitalized.toString()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                (displayedData.newHospitalized > 0 ? "+" : '-') + displayedData.newHospitalized.toString() + " durant les dernières 24 heures",
                                style: TextStyle(color: displayedData.newHospitalized > 0 ? Colors.red : Colors.green),
                              ),
                            ],
                          ),
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
                          TextHeadline6(text: 'Réanimations'),
                          TextHeadline5(text: displayedData.reanimation.toString()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                (displayedData.newReanimation > 0 ? "+" : '-') + displayedData.newReanimation.toString() + " durant les dernières 24 heures",
                                style: TextStyle(color: displayedData.newHospitalized > 0 ? Colors.red : Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ReusableCard(
                            colour: Theme.of(context).cardColor,
                            cardChild: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextHeadline6(text: 'Décès'),
                                TextHeadline5(text: displayedData.deaths.toString()),
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
                                TextHeadline6(text: 'Guéris'),
                                TextHeadline5(text: displayedData.healed.toString()),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Source", style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center),
                  SizedBox(height: 10),
                  Text(displayedData.sourceName + ' le ' + displayedData.date, textAlign: TextAlign.center),
                  SizedBox(height: 20),
                ],
              ),
            )
          ]
      );
    }

    return _isLoading ?
      ScreenLayouts.loadingWithDescription("Chargement des informations épidémiologiques") :
      FadeScaleTransition(
      animation: _controller,
      child: SmartRefresher(
          enablePullDown: true,
          header: WaterDropMaterialHeader(
            backgroundColor: Theme.of(context).accentColor,
            color: Theme.of(context).cardColor,
          ),
          controller: _refreshController,
          onRefresh: _load,
          child: _getBodyContent()
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}