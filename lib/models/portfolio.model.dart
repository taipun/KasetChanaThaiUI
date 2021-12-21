class Portfolio {
  String pUserId;
  List<PortfolioItem> items;

  Portfolio({this.pUserId, this.items});

  factory Portfolio.fromJson(Map<String, dynamic> parsedJson) {
    try {
      var itemsList = (parsedJson['items'] ?? []) as List;
      return Portfolio(
        pUserId: parsedJson['p_user_id'],
        items: itemsList.isNotEmpty
            ? itemsList
                .map((element) => PortfolioItem.fromJson(element))
                .toList()
            : [],
      );
    } catch (ex) {
      print('PortfolioModel Portfolio ====> $ex');
      throw ('factory Portfolio.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {'p_user_id': pUserId, 'items': items};
}

class PortfolioItem {
  String productId;
  String name;
  int volume;
  double price;

  PortfolioItem({this.productId, this.name, this.volume, this.price});

  factory PortfolioItem.fromJson(Map<String, dynamic> parsedJson) {
    try {
      return PortfolioItem(
          productId: parsedJson['product_id'],
          name: parsedJson['name'],
          volume: parsedJson['volume'],
          price: double.parse(parsedJson['price'].toString()));
    } catch (ex) {
      print('PortfolioItemModel PortfolioItem ====> $ex');
      throw ('factory PortfolioItem.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() =>
      {'product_id': productId, 'name': name, 'volume': volume, 'price': price};
}
