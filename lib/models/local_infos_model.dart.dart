import 'package:digimobile/models/infos_model.dart';

class LocalInfosModel extends InfosModel {

  String department;

  LocalInfosModel.fromData(Map<String, dynamic> localData){
    this.date         = localData["date"];
    this.sourceName   = localData["source"]["nom"];
    this.hospitalized = localData["hospitalises"];
    this.deaths       = localData["deces"];
    this.healed       = localData["gueris"];
    this.reanimation  = localData["reanimation"];
    this.department   = localData["nom"];
    this.newHospitalized = localData["nouvellesHospitalisations"];
    this.newReanimation  = localData["nouvellesReanimations"];
  }

}