class CurrencyRate {
  String? title;
  String? code;
  String? cbPrice;
  String? buyPrice;
  String? cellPrise;
  String? date;

  CurrencyRate(this.title, this.code, this.cbPrice, this.buyPrice,
      this.cellPrise, this.date);

  CurrencyRate.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    code = json['code'];
    cbPrice = json['cb_price'];
    buyPrice = json['nbu_buy_price'];
    cellPrise = json['nbu_cell_price'];
    date = json['date'];
  }
}
