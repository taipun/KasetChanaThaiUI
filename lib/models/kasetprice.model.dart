class Kasetprice {
  String priceProdType;
  String priceDate;
  String pricePrProdName;
  String priceMarketName;
  String priceDay;

  Kasetprice({
    this.priceProdType,
    this.priceDate,
    this.pricePrProdName,
    this.priceMarketName,
    this.priceDay,
  });

  factory Kasetprice.fromJson(Map<String, dynamic> parsedJson) {
    try {
      // print(parsedJson);
      return Kasetprice(
        priceProdType: parsedJson['PROD_TYPE'],
        priceDate: parsedJson['PRICE_DATE'],
        pricePrProdName: parsedJson['PR_PROD_NAME'],
        priceMarketName: parsedJson['MARKET_NAME'],
        priceDay: parsedJson['PRICE_DAY'],
      );
    } catch (ex) {
      print('KasetpriceModel Kasetprice ====> $ex');
      throw ('factory Kasetprice.fromJson ====> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
        'PROD_TYPE': priceProdType,
        'PRICE_DATE': priceDate,
        'PR_PROD_NAME': pricePrProdName,
        'MARKET_NAME': priceMarketName,
        'PRICE_DAY': priceDay,
      };
}
