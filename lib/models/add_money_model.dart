class AddMoneyItem {
  static String addMoneyChipsKey = "addMoney_chips";
  static String addMoneyPriceKey = "addMoney_price";
  AddMoneyItem({
    this.addMoneyChips = "",
    this.addMoneyPrice = "",
  });

  String addMoneyChips;
  String addMoneyPrice;

  factory AddMoneyItem.fromJson(Map<String, dynamic> json) => AddMoneyItem(
        addMoneyChips: json[AddMoneyItem.addMoneyChipsKey] ?? "",
        addMoneyPrice: json[AddMoneyItem.addMoneyPriceKey] ?? "",
      );

  Map<String, dynamic> toJson() => {
        AddMoneyItem.addMoneyChipsKey: addMoneyChips,
        AddMoneyItem.addMoneyPriceKey: addMoneyPrice,
      };
}
