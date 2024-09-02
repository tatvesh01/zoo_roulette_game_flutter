class WithdrawItem {
  static String noKey = "No";
  static String amountKey = "Amount";
  static String timeKey = "Time";
  static String statusKey = "Status";
  static String reasonKey = "Reason";
  WithdrawItem({
    this.no = "",
    this.amount = "",
    this.time = "",
    this.status = "",
    this.reason = "",
  });

  String no;
  String amount;
  String time;
  String status;
  String reason;

  factory WithdrawItem.fromJson(Map<String, dynamic> json) => WithdrawItem(
        no: json[noKey] ?? "",
        amount: json[amountKey] ?? "",
        time: json[timeKey] ?? "",
        status: json[statusKey] ?? "",
        reason: json[reasonKey] ?? "",
      );

  Map<String, dynamic> toJson() => {
        noKey: no,
        amountKey: amount,
        timeKey: time,
        statusKey: status,
        reasonKey: reason,
      };
}
