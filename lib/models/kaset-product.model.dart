class KasetProduct {
  String productId;
  String productName;
  String categoryName;
  double productPrice;

  KasetProduct(
      {this.productId, this.productName, this.categoryName, this.productPrice});

  factory KasetProduct.fromJson(Map<String, dynamic> parsedJson) {
    try {
      // print(parsedJson);
      return KasetProduct(
          productId: parsedJson['product_id'],
          productName: parsedJson['product_name'],
          categoryName: parsedJson['category_name'],
          productPrice: double.parse(parsedJson['product_price'].toString()));
    } catch (ex) {
      print('KasetProductModel KasetProduct ====> $ex');
      throw ('factory KasetProduct.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'product_name': productName,
        'category_name': categoryName,
        'product_price': productPrice ?? 0.0,
      };
}

class KasetProductGroup {
  String groupName;

  KasetProductGroup({this.groupName});

  factory KasetProductGroup.fromJson(Map<String, dynamic> parsedJson) {
    try {
      // print(parsedJson);
      return KasetProductGroup(groupName: parsedJson['_id']);
    } catch (ex) {
      print('KasetProductGroupModel KasetProductGroup ====> $ex');
      throw ('factory KasetProductGroup.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {'_id': groupName};
}
