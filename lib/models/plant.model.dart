class Plant {
  String plantId;
  int plantNumberId;
  String plantName;
  String plantDescription;
  int plantTime;
  int plantPersqrmeter;
  bool plantIsDeleted;
  String plantPhoto;

  Plant(
      {this.plantId,
      this.plantNumberId,
      this.plantName,
      this.plantDescription,
      this.plantTime,
      this.plantPersqrmeter,
      this.plantIsDeleted,
      this.plantPhoto});

  factory Plant.fromJson(Map<String, dynamic> parsedJson) {
    try {
      // print(parsedJson);
      return Plant(
          plantId: parsedJson['_id'],
          plantNumberId: parsedJson['plant_id'],
          plantName: parsedJson['name'],
          plantDescription: parsedJson['description'],
          plantTime: parsedJson['planttime'],
          plantPersqrmeter: parsedJson['plantpersqrmeter'],
          plantIsDeleted: parsedJson['isDeleted'],
          plantPhoto: parsedJson['photo']);
    } catch (ex) {
      print('PlantModel Plant ====> $ex');
      throw ('factory Plant.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
        '_id': plantId,
        'plant_id': plantNumberId,
        'name': plantName,
        'description': plantDescription,
        'planttime': plantTime,
        'plantpersqrmeter': plantPersqrmeter,
        'isDeleted': plantIsDeleted,
        'photo': plantPhoto,
      };
}
