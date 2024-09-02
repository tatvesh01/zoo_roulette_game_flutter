class SelectedItem {
  static String selectedItemIndexKey = "selected_item_index";
  static String selectedItemAmountKey = "selected_item_amount";
  static String selectedItemNameKey = "selected_item_name";
  SelectedItem({
    this.selectedItemIndex = 0,
    this.selectedItemAmount = 0,
    this.selectedItemName = '',
  });

  int selectedItemIndex;
  int selectedItemAmount;
  String selectedItemName;

  factory SelectedItem.fromJson(Map<String, dynamic> json) => SelectedItem(
        selectedItemIndex: json[SelectedItem.selectedItemIndexKey] ?? -1,
        selectedItemAmount: json[SelectedItem.selectedItemAmountKey] ?? -1,
        selectedItemName: json[SelectedItem.selectedItemNameKey] ?? '',
      );

  Map<String, dynamic> toJson() => {
        SelectedItem.selectedItemIndexKey: selectedItemIndex,
        SelectedItem.selectedItemAmountKey: selectedItemAmount,
        SelectedItem.selectedItemNameKey: selectedItemName,
      };
}
