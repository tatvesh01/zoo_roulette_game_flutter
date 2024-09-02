class RecordItem {
  static String recordItemIndexByWheelKey = "record_item_index_by_wheel";
  static String recordItemNameKey = "record_item_name";
  static String recordItemImgPathKey = "record_item_img_path";
  RecordItem({
    this.recordItemIndexByWheel = 0,
    this.recordItemName = "",
    required this.recordItemImgpath,
  });
  int recordItemIndexByWheel;
  String recordItemName;
  String recordItemImgpath;

  factory RecordItem.fromJson(Map<String, dynamic> json) => RecordItem(
        recordItemIndexByWheel: json[RecordItem.recordItemIndexByWheelKey] ?? -1,
        recordItemName: json[RecordItem.recordItemNameKey] ?? "",
        recordItemImgpath: json[recordItemImgPathKey] ?? "",
      );

  Map<String, dynamic> toJson() => {
        RecordItem.recordItemIndexByWheelKey: recordItemIndexByWheel,
        RecordItem.recordItemNameKey: recordItemName,
        recordItemImgPathKey: recordItemImgpath,
      };
}

/* class RecordsDataModel {
  RecordsDataModel({
    this.userCurrentBalance = 0,
    this.recordItems = const <RecordItem>[],
    this.playerId = '',
  });

  int userCurrentBalance;
  List<RecordItem> recordItems;
  String playerId;

  factory RecordsDataModel.fromJson(Map<String, dynamic> json) => RecordsDataModel(
        userCurrentBalance: json[userCurrentBalanceKey],
        recordItems: json[selectedBetItemsKey] != null
            ? List<SelectedItem>.from(json[selectedBetItemsKey].map((x) => SelectedItem.fromJson(x)))
            : const <SelectedItem>[],
        playerId: json[playerIdkey],
      );

  Map<String, dynamic> toJson() => {
        userCurrentBalanceKey: userCurrentBalance,
        selectedBetItemsKey: List<dynamic>.from(recordItems.map((x) => x.toJson())),
        playerIdkey: playerId,
      };
} */