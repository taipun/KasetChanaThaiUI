class Region {
  String nameThai;
  String nameEng;

  Region({this.nameThai, this.nameEng});

  factory Region.fromJson(Map<String, dynamic> parsedJson) {
    try {
      return Region(
        nameThai: parsedJson['name_thai'].toString(),
        nameEng: parsedJson['name_eng'].toString(),
      );
    } catch (ex) {
      print('RegionModel Region ====> $ex');
      throw ('factory Region.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
        'name_thai': nameThai,
        'name_eng': nameEng,
      };
}
