import 'dart:math';

class BetCountOnEach {
  static String swallowKey = "swallow";
  static String monkeyKey = "monkey";
  static String eagleKey = "eagle";
  static String pandaKey = "panda";
  static String sharkKey = "shark";
  static String peacockKey = "peacock";
  static String rabbitKey = "rabbit";
  static String pigeonKey = "pigeon";
  static String lionKey = "lion";
  static String frogKey = "frog";
  BetCountOnEach({
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

  factory BetCountOnEach.fromJson(Map<String, dynamic> json) => BetCountOnEach(
        swallow: json[swallowKey] ?? Random().nextInt(1589) + 1258,
        monkey: json[monkeyKey] ?? Random().nextInt(1589) + 1258,
        eagle: json[eagleKey] ?? Random().nextInt(1589) + 1258,
        panda: json[pandaKey] ?? Random().nextInt(1589) + 1258,
        shark: json[sharkKey] ?? Random().nextInt(146) + 58,
        peacock: json[peacockKey] ?? Random().nextInt(1589) + 1258,
        rabbit: json[rabbitKey] ?? Random().nextInt(1589) + 1258,
        pigeon: json[pigeonKey] ?? Random().nextInt(1589) + 1258,
        lion: json[lionKey] ?? Random().nextInt(1589) + 1258,
        frog: json[frogKey] ?? Random().nextInt(185) + 58,
      );

  Map<String, dynamic> toJson() => {
        swallowKey: swallow,
        monkeyKey: monkey,
        eagleKey: eagle,
        pandaKey: panda,
        sharkKey: shark,
        peacockKey: peacock,
        rabbitKey: rabbit,
        pigeonKey: pigeon,
        lionKey: lion,
        frogKey: frog,
      };
}
