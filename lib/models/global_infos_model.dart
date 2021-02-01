import 'package:digimobile/models/infos_model.dart';

class GlobalInfosModel extends InfosModel {


  GlobalInfosModel.fromData(Map<String, dynamic> globalData){
    this.date         = globalData["date"];
    this.sourceName   = globalData["source"]["nom"];
    this.hospitalized = globalData["hospitalises"];
    this.deaths       = globalData["deces"];
    this.healed       = globalData["gueris"];
    this.reanimation  = globalData["reanimation"];
    this.newHospitalized = globalData["nouvellesHospitalisations"];
    this.newReanimation  = globalData["nouvellesReanimations"];
  }

}