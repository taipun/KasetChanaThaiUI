class Watch {
  String uId;
  List<WatchItem> items;
  int no;

  Watch({this.uId, this.items, this.no});

  factory Watch.fromJson(Map<String, dynamic> parsedJson) {
    try {
      var itemsList = (parsedJson['watchlist_no'] ?? []) as List;
      return Watch(
        uId: parsedJson['u_id'],
        items: itemsList.isNotEmpty
            ? itemsList.map((element) => WatchItem.fromJson(element)).toList()
            : [],
        no: parsedJson['no'],
      );
    } catch (ex) {
      print('WatchModel Watch ====> $ex');
      throw ('factory Watch.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() =>
      {'u_id': uId, 'watchlist_no': items, 'no': no};
}

class WatchItem {
  String productId;
  String name;
  double price;

  WatchItem({this.productId, this.name, this.price});

  factory WatchItem.fromJson(Map<String, dynamic> parsedJson) {
    try {
      return WatchItem(
          productId: parsedJson['product_id'],
          name: parsedJson['name'],
          price: double.parse(parsedJson['price'].toString()));
    } catch (ex) {
      print('WatchItemModel WatchItem ====> $ex');
      throw ('factory WatchItem.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() =>
      {'product_id': productId, 'name': name, 'price': price};
}
