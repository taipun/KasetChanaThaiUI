class KasetProductPrice {
  String productId;
  String productName;
  String groupName;
  double price;
  String date;

  KasetProductPrice(
      {this.productId,
      this.productName,
      this.groupName,
      this.price,
      this.date});

  factory KasetProductPrice.fromJson(Map<String, dynamic> parsedJson) {
    try {
      // print(parsedJson);
      return KasetProductPrice(
          productId: parsedJson['product_id'],
          productName: parsedJson['product_name'],
          groupName: parsedJson['group_name'],
          price: double.parse(parsedJson['price_max_avg'].toString()),
          date: parsedJson['date']);
    } catch (ex) {
      print('KasetProductPriceModel KasetProductPrice ====> $ex');
      throw ('factory KasetProductPrice.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'product_name': productName,
        'group_name': groupName,
        'price_max_avg': price,
        'date': date,
      };
}
