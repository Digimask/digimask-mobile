
import 'package:digimobile/models/global_infos_model.dart';
import 'package:digimobile/models/infos_model.dart';
import 'package:digimobile/models/local_infos_model.dart.dart';
import 'package:digimobile/utils/constants.dart';
import 'package:digimobile/utils/network.dart';
import 'package:geolocator/geolocator.dart';

class InfosService {

  Future<InfosModel> getGlobalData() async {

    // Set the API call
    String baseURL = "https://coronavirusapi-france.now.sh/FranceLiveGlobalData";

    // Execute the API call
    var response = await Network().get(baseURL);

    // Create app objects
    return GlobalInfosModel.fromData(response["FranceGlobalLiveData"][0]);
  }

  Future<InfosModel> getLocalData() async {

    // First, check if GPS data can be retrieved
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // GPS services are not turned on
      return null;
    }

    // Set the API call
    String baseURL    = "https://coronavirusapi-france.now.sh/LiveDataByDepartement?Departement=";
    String department = await getDepartment();
    String url        = baseURL + department;

    // Execute the API call
    var response = await Network().get(url);

    // Create app objects
    return LocalInfosModel.fromData(response["LiveDataByDepartement"][0]);
  }

  Future<String> getDepartment() async {

    // Get last known position
    Position _position = await Geolocator.getLastKnownPosition();
    if (_position == null){
      // If no position has been returned, get current position
      _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);
    }


    // Set the API call
    String baseURL   = "https://maps.googleapis.com/maps/api/geocode/json?latlng=";
    double latitude  = _position.latitude;
    double longitude = _position.longitude;
    String url       = baseURL + latitude.toString() + ',' + longitude.toString() + "&key=" + googleApiKey;

    // Execute the API call
    var response = await Network().get(url);

    // Create app objects
    return response["results"][0]["address_components"][3]["long_name"];

  }
}