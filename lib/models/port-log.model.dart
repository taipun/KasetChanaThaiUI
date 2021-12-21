class PortLog {
  String logId;
  String userId;
  double price;
  String date;

  PortLog({this.logId, this.userId, this.price, this.date});

  factory PortLog.fromJson(Map<String, dynamic> parsedJson) {
    try {
      // print(parsedJson);
      return PortLog(
          logId: parsedJson['_id'],
          userId: parsedJson['user_id'],
          price: double.parse(parsedJson['price'].toString()),
          date: parsedJson['created_at'].toString());
    } catch (ex) {
      print('PortLogModel PortLog ====> $ex');
      throw ('factory PortLog.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
        '_id': logId,
        'user_id': userId,
        'price': price,
      };
}
