import 'bet_count_on_each.dart';

class RoundArrayModel {
  RoundArrayModel({
    this.roundArray = const <RoundArray>[],
  });

  List<RoundArray> roundArray;

  factory RoundArrayModel.fromJson(Map<String, dynamic> json) => RoundArrayModel(
        roundArray: json["RoundArray"] != null ? List<RoundArray>.from(json["RoundArray"].map((x) => RoundArray.fromJson(x))) : [],
      );

  Map<String, dynamic> toJson() => {
        "RoundArray": List<dynamic>.from(roundArray.map((x) => x.toJson())),
      };
}

class RoundArray {
  RoundArray({
    this.whereToStop = 0,
    required this.betBotChips,
    required this.increment,
  });

  int whereToStop;
  BetCountOnEach betBotChips;
  BetCountOnEach increment;

  factory RoundArray.fromJson(Map<String, dynamic> json) => RoundArray(
        whereToStop: json["whereTOStop"] ?? 0,
        betBotChips: json["betBotChips"] != null ? BetCountOnEach.fromJson(json["betBotChips"]) : BetCountOnEach(),
        increment: json["increment"] != null ? BetCountOnEach.fromJson(json["increment"]) : BetCountOnEach(),
      );

  Map<String, dynamic> toJson() => {
        "whereTOStop": whereToStop,
        "betBotChips": betBotChips.toJson(),
        "increment": increment.toJson(),
      };
}

class BetBotChips {
  BetBotChips({
    this.swallow = 0,
    this.monkey = 0,
    this.eagle = 0,
    this.panda = 0,
    this.shark = 0,
    this.peacock = 0,
    this.rabbit = 0,
    this.pigeon = 0,
    this.lion = 0,
    this.frog = 0,
  });

  int swallow;
  int monkey;
  int eagle;
  int panda;
  int shark;
  int peacock;
  int rabbit;
  int pigeon;
  int lion;
  int frog;

  factory BetBotChips.fromJson(Map<String, dynamic> json) => BetBotChips(
        swallow: json["Swallow"] ?? 0,
        monkey: json["Monkey"] ?? 0,
        eagle: json["Eagle"] ?? 0,
        panda: json["Panda"] ?? 0,
        shark: json["Shark"] ?? 0,
        peacock: json["Peacock"] ?? 0,
        rabbit: json["Rabbit"] ?? 0,
        pigeon: json["Pigeon"] ?? 0,
        lion: json["Lion"] ?? 0,
        frog: json["Frog"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "Swallow": swallow,
        "Monkey": monkey,
        "Eagle": eagle,
        "Panda": panda,
        "Shark": shark,
        "Peacock": peacock,
        "Rabbit": rabbit,
        "Pigeon": pigeon,
        "Lion": lion,
        "Frog": frog,
      };
}
