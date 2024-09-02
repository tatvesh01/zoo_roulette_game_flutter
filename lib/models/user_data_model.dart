import 'package:zoo_zimba/globles.dart';
import 'package:zoo_zimba/models/withdraw_model.dart';
import 'selected_item_model.dart';

class AllUserDataModel {
  AllUserDataModel({
    this.userDataModel = const <UserDataModel>[],
  });

  List<UserDataModel> userDataModel;

  factory AllUserDataModel.fromJson(Map<String, dynamic> json) => AllUserDataModel(
        userDataModel: json["userDataModel"] != null
            ? List<UserDataModel>.from(json["userDataModel"].map((x) => UserDataModel.fromJson(x)))
            : const <UserDataModel>[],
      );

  Map<String, dynamic> toJson() => {
        "userDataModel": List<dynamic>.from(userDataModel.map((x) => x.toJson())),
      };
}

class UserDataModel {
  UserDataModel({
    this.userCurrentBalance = 0,
    this.selectedBetItems = const <SelectedItem>[],
    this.withdrawListItems = const <WithdrawItem>[],
    this.addMoneyListItems = const <WithdrawItem>[],
    this.playerId = '',
  });

  int userCurrentBalance;
  List<SelectedItem> selectedBetItems;
  List<WithdrawItem> withdrawListItems;
  List<WithdrawItem> addMoneyListItems;
  String playerId;

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        userCurrentBalance: json[userCurrentBalanceKey] ?? 0,
        selectedBetItems: json[selectedBetItemsKey] != null
            ? List<SelectedItem>.from(json[selectedBetItemsKey].map((x) => SelectedItem.fromJson(x)))
            : const <SelectedItem>[],
        withdrawListItems: json[withdrawListKey] != null
            ? List<WithdrawItem>.from(json[withdrawListKey].map((x) => WithdrawItem.fromJson(x)))
            : const <WithdrawItem>[],
        addMoneyListItems: json[addMoneyListKey] != null
            ? List<WithdrawItem>.from(json[addMoneyListKey].map((x) => WithdrawItem.fromJson(x)))
            : const <WithdrawItem>[],
        playerId: json[playerIdkey],
      );

  Map<String, dynamic> toJson() => {
        userCurrentBalanceKey: userCurrentBalance,
        selectedBetItemsKey: List<dynamic>.from(selectedBetItems.map((x) => x.toJson())),
        withdrawListKey: List<dynamic>.from(withdrawListItems.map((x) => x.toJson())),
        addMoneyListKey: List<dynamic>.from(addMoneyListItems.map((x) => x.toJson())),
        playerIdkey: playerId,
      };
}
