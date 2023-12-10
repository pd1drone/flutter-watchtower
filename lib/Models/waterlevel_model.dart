class WaterLevelData {
  late final int ID;
  final double WaterLevel;
  final int Timestamp;

  WaterLevelData(this.ID, this.WaterLevel,this.Timestamp);

  WaterLevelData.fromMap(Map<String, dynamic> item)
      : ID = item["ID"],
        WaterLevel = item["WaterLevel"].toDouble(),
        Timestamp = item["Timestamp"];

  Map<String, dynamic> toMap() {
    return {
      'ID': ID,
      'WaterLevel': WaterLevel,
      'Timestamp': Timestamp
    };
  }
}