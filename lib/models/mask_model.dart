import 'package:digimobile/models/db_model.dart';
import 'package:digimobile/services/db_service.dart';
import 'package:flutter/cupertino.dart';

class Mask extends DBModel{

  int _id;
  String  _type;
  Duration _remainingTime;
  int _washingCounter;

  bool get isSurgical => _type == "surgical";
  bool get isReusable => _type == "reusable";
  Duration get remainingTime => _remainingTime;
  int get currentWashingCounter => _washingCounter;
  int get maxWashingCounter => 30;

  updateRemainingTime(Duration duration){
    this._remainingTime = duration;
  }

  incrementWashingCounter() async {
    if(this._washingCounter<30){
      this._washingCounter++;
      this._remainingTime = Duration(hours: 4);
      await this.update();
    }
  }

  decrementWashingCounter() async {
    if(this._washingCounter>0){
      this._washingCounter--;
      await this.update();
    }
  }

  Mask(dynamic content){
    this._id = content["maskID"];
    this._type = content["properties"]["type"];
    this._remainingTime = content["properties"]["duration"] != null ? Duration(seconds: content["properties"]["duration"]) : Duration(hours: 4);
    this._washingCounter = 0;
  }

  Mask.fromDB({@required int id, @required String type, @required int remainingTime, @required int washingCounter}){
    this._id = id;
    this._type = type;
    this._remainingTime = Duration(seconds: remainingTime);
    this._washingCounter = washingCounter;
  }

  @override
  Map<String, dynamic> toDB(){
    return {
      DBService.db.masksFieldmaskID: _id,
      DBService.db.masksFieldtype: _type,
      DBService.db.masksFieldremainingTime: _remainingTime.inSeconds,
      DBService.db.masksFieldwashingCounter: _washingCounter
    };
  }

  @override
  Future<void> insert() async {
    DBService.db.insert(this, DBService.db.masksTableName);
  }

  @override
  Future<void> update() async {
    DBService.db.update(this, DBService.db.masksTableName);
  }

  @override
  String getIDFieldName() {
    return DBService.db.masksFieldmaskID;
  }

  @override
  int getID() {
    return this._id;
  }}