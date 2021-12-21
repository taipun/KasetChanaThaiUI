class Kasetplan {
  String kasetId;
  String kasetUId;
  int kasetNo;
  List<KasetplanAsset> kasetAsset;
  int kasetEsimate;
  bool kasetIsDeleted;
  bool isActive;
  String planName;
  String mapLat;
  String mapLng;
  double mapZoom;

  Kasetplan({
    this.kasetId,
    this.kasetUId,
    this.kasetNo,
    this.kasetAsset,
    this.kasetEsimate,
    this.kasetIsDeleted,
    this.isActive,
    this.planName,
    this.mapLat,
    this.mapLng,
    this.mapZoom,
  });

  factory Kasetplan.fromJson(Map<String, dynamic> parsedJson) {
    try {
      var kasetAssetList = (parsedJson['asset'] ?? []) as List;
      return Kasetplan(
        kasetId: parsedJson['_id'] ?? '',
        kasetUId: parsedJson['u_id'] ?? '',
        kasetNo: int.parse(parsedJson['no'].toString()) ?? 0,
        kasetAsset: kasetAssetList.isNotEmpty
            ? kasetAssetList
                .map((element) => KasetplanAsset.fromJson(element))
                .toList()
            : [],
        kasetEsimate: int.parse(parsedJson['esimate'].toString()) ?? 0,
        kasetIsDeleted: parsedJson['isDeleted'] ?? false,
        isActive: parsedJson['isActive'] ?? false,
        planName: parsedJson['planName'] ?? '',
        mapLat: parsedJson['mapLat'] ?? '0',
        mapLng: parsedJson['mapLng'] ?? '0',
        mapZoom: double.tryParse(parsedJson['mapZoom'].toString()) != null
            ? double.parse(parsedJson['mapZoom'].toString())
            : 15,
      );
    } catch (ex) {
      print('KasetplanModel Kasetplan ====> $ex');
      throw ('factory Kasetplan.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
        '_id': kasetId ?? '',
        'u_id': kasetUId ?? '',
        'no': kasetNo ?? 0,
        'asset': kasetAsset,
        'esimate': kasetEsimate ?? 0,
        'isDeleted': kasetIsDeleted ?? false,
        'isActive': isActive ?? false,
        'planName': planName ?? '',
        'mapLat': mapLat ?? '0',
        'mapLng': mapLng ?? '0',
        'mapZoom': mapZoom ?? 15,
      };
}

class KasetplanAsset {
  String assetId;
  int assetVolume;
  int assetPlantId;
  String assetName;
  int assetDay;
  bool assetAuto;
  int assetPrice;
  String assetPhoto;

  KasetplanAsset(
      {this.assetId,
      this.assetVolume,
      this.assetPlantId,
      this.assetName,
      this.assetDay,
      this.assetAuto,
      this.assetPrice,
      this.assetPhoto});

  factory KasetplanAsset.fromJson(Map<String, dynamic> parsedJson) {
    try {
      return KasetplanAsset(
          assetId: parsedJson['_id'] ?? '',
          assetVolume: parsedJson['volume'] ?? 0,
          assetPlantId: int.parse(parsedJson['plant_id'].toString()) ?? 0,
          assetName: parsedJson['name'] ?? '',
          assetDay: int.parse(parsedJson['day'].toString()) ?? 0,
          assetAuto: parsedJson['auto'] ?? false,
          assetPrice: parsedJson['price'] ?? 0,
          assetPhoto: parsedJson['photo'] ?? '');
    } catch (ex) {
      print('KasetplanModel Kasetplan ====> $ex');
      throw ('factory Kasetplan.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
        '_id': assetId,
        'volume': assetVolume,
        'plant_id': assetPlantId,
        'name': assetName,
        'day': assetDay,
        'auto': assetAuto,
        'price': assetPrice,
        'photo': assetPhoto,
      };
}
