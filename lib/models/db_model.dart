abstract class DBModel {
  Future<void> insert();
  Future<void> update();
  Map<String, dynamic> toDB();
  String getIDFieldName();
  int getID();
}