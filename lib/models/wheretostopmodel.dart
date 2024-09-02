class WhereToStopObj {
  WhereToStopObj({
    this.whereToStop = 0,
    this.whereToStopIndex = 0,
  });

  int whereToStop;
  int whereToStopIndex;

  factory WhereToStopObj.fromJson(Map<String, dynamic> json) => WhereToStopObj(
        whereToStop: json["whereTOStop"] ?? 0,
        whereToStopIndex: json["whereTOStopIndex"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "whereTOStop": whereToStop,
        "whereTOStopIndex": whereToStopIndex,
      };
}
