import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zoo_zimba/globles.dart';
import 'package:zoo_zimba/models/bet_count_on_each.dart';

import '../models/round_array_model.dart';
import '../models/selected_item_model.dart';
import '../models/user_data_model.dart';

class DashBoardController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isPlay = false.obs;
  RxInt whereTOStopCount = Random().nextInt(10).obs;
  RxInt cycleNo = 0.obs;
  RxInt currentSec = 0.obs;
  List<StreamSubscription> streams = [];
  StreamSubscription? userBettingStream;
  final database = FirebaseDatabase.instance.ref();
  FocusNode ipNode = FocusNode();
  TextEditingController connectionIp = TextEditingController();
  late Timer every15sec;
  late Timer every1sec;
  RxList userDataList = RxList();
  /////================================================Model Version======RecordList============================================
  /*  RxList<RecordItem> recordItemsList = RxList(); */
  /////================================================int Version======RecordList============================================
  RxList<int> recordItemsList = RxList();
  Timer? onlineUsersCountTimer;
  RxInt onlineUsersCount = (Random().nextInt(96) + 67).obs;
  Rx<BetCountOnEach> betCountOnEach = BetCountOnEach().obs;
  RxList<RoundArray> roundArray = [
    RoundArray(
      whereToStop: 1,
      betBotChips: BetCountOnEach(
        swallow: 5220,
        monkey: 3210,
        eagle: 2340,
        panda: 4210,
        shark: 60,
        peacock: 4720,
        rabbit: 2980,
        pigeon: 1520,
        lion: 1950,
        frog: 20,
      ),
      increment: BetCountOnEach(
        swallow: 1960,
        monkey: 1520,
        eagle: 1840,
        panda: 1920,
        shark: 120,
        peacock: 1920,
        rabbit: 1960,
        pigeon: 1920,
        lion: 1840,
        frog: 120,
      ),
    ),
    RoundArray(
      whereToStop: 0,
      betBotChips: BetCountOnEach(
        swallow: 2520,
        monkey: 1810,
        eagle: 3640,
        panda: 1110,
        shark: 20,
        peacock: 3520,
        rabbit: 2680,
        pigeon: 1120,
        lion: 3550,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 860,
        monkey: 220,
        eagle: 440,
        panda: 320,
        shark: 60,
        peacock: 520,
        rabbit: 460,
        pigeon: 220,
        lion: 640,
        frog: 80,
      ),
    ),
    RoundArray(
      whereToStop: 5,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 1840,
        panda: 610,
        shark: 30,
        peacock: 2220,
        rabbit: 1680,
        pigeon: 1520,
        lion: 2550,
        frog: 40,
      ),
      increment: BetCountOnEach(
        swallow: 660,
        monkey: 220,
        eagle: 340,
        panda: 420,
        shark: 80,
        peacock: 920,
        rabbit: 560,
        pigeon: 320,
        lion: 450,
        frog: 60,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 2520,
        monkey: 2210,
        eagle: 2240,
        panda: 1110,
        shark: 60,
        peacock: 1620,
        rabbit: 1980,
        pigeon: 1220,
        lion: 2450,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 355,
        panda: 425,
        shark: 100,
        peacock: 420,
        rabbit: 350,
        pigeon: 320,
        lion: 550,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 2120,
        monkey: 2210,
        eagle: 2240,
        panda: 2510,
        shark: 60,
        peacock: 1620,
        rabbit: 1980,
        pigeon: 1220,
        lion: 2450,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 355,
        panda: 625,
        shark: 80,
        peacock: 420,
        rabbit: 350,
        pigeon: 320,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 6,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 240,
        panda: 810,
        shark: 100,
        peacock: 1220,
        rabbit: 3080,
        pigeon: 1020,
        lion: 2050,
        frog: 80,
      ),
      increment: BetCountOnEach(
        swallow: 860,
        monkey: 420,
        eagle: 455,
        panda: 325,
        shark: 100,
        peacock: 520,
        rabbit: 850,
        pigeon: 220,
        lion: 650,
        frog: 80,
      ),
    ),
    RoundArray(
      whereToStop: 4,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 240,
        panda: 810,
        shark: 150,
        peacock: 1220,
        rabbit: 3080,
        pigeon: 1020,
        lion: 2050,
        frog: 80,
      ),
      increment: BetCountOnEach(
        swallow: 850,
        monkey: 420,
        eagle: 450,
        panda: 325,
        shark: 100,
        peacock: 1120,
        rabbit: 850,
        pigeon: 240,
        lion: 630,
        frog: 10,
      ),
    ),
    RoundArray(
      whereToStop: 7,
      betBotChips: BetCountOnEach(
        swallow: 820,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1620,
        lion: 2050,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 1240,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 0,
      betBotChips: BetCountOnEach(
        swallow: 520,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1620,
        lion: 2050,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 350,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 1240,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 0,
      betBotChips: BetCountOnEach(
        swallow: 620,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1220,
        lion: 1150,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 450,
        monkey: 320,
        eagle: 250,
        panda: 685,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 140,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 5,
      betBotChips: BetCountOnEach(
        swallow: 520,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 1230,
        rabbit: 880,
        pigeon: 920,
        lion: 550,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 40,
        peacock: 920,
        rabbit: 550,
        pigeon: 1240,
        lion: 530,
        frog: 60,
      ),
    ),
    RoundArray(
      whereToStop: 5,
      betBotChips: BetCountOnEach(
        swallow: 520,
        monkey: 610,
        eagle: 1040,
        panda: 910,
        shark: 80,
        peacock: 1630,
        rabbit: 880,
        pigeon: 920,
        lion: 550,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 40,
        peacock: 1020,
        rabbit: 550,
        pigeon: 1040,
        lion: 530,
        frog: 60,
      ),
    ),
    RoundArray(
      whereToStop: 8,
      betBotChips: BetCountOnEach(
        swallow: 1020,
        monkey: 810,
        eagle: 1240,
        panda: 1110,
        shark: 120,
        peacock: 1120,
        rabbit: 1080,
        pigeon: 820,
        lion: 1550,
        frog: 40,
      ),
      increment: BetCountOnEach(
        swallow: 450,
        monkey: 460,
        eagle: 250,
        panda: 685,
        shark: 50,
        peacock: 720,
        rabbit: 150,
        pigeon: 140,
        lion: 980,
        frog: 30,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 2120,
        monkey: 2210,
        eagle: 2240,
        panda: 2410,
        shark: 60,
        peacock: 1620,
        rabbit: 1980,
        pigeon: 1220,
        lion: 2450,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 355,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 350,
        pigeon: 320,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 2,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 2240,
        panda: 1410,
        shark: 80,
        peacock: 1220,
        rabbit: 1780,
        pigeon: 1520,
        lion: 2050,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 205,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 250,
        pigeon: 620,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 6,
      betBotChips: BetCountOnEach(
        swallow: 620,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 680,
        pigeon: 1220,
        lion: 1150,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 450,
        monkey: 320,
        eagle: 250,
        panda: 685,
        shark: 50,
        peacock: 720,
        rabbit: 450,
        pigeon: 140,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 1,
      betBotChips: BetCountOnEach(
        swallow: 620,
        monkey: 610,
        eagle: 1540,
        panda: 810,
        shark: 80,
        peacock: 1230,
        rabbit: 850,
        pigeon: 620,
        lion: 550,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 420,
        eagle: 250,
        panda: 985,
        shark: 40,
        peacock: 520,
        rabbit: 350,
        pigeon: 640,
        lion: 530,
        frog: 60,
      ),
    ),
    RoundArray(
      whereToStop: 1,
      betBotChips: BetCountOnEach(
        swallow: 620,
        monkey: 1110,
        eagle: 1040,
        panda: 810,
        shark: 80,
        peacock: 1030,
        rabbit: 850,
        pigeon: 620,
        lion: 850,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 250,
        monkey: 550,
        eagle: 250,
        panda: 985,
        shark: 40,
        peacock: 320,
        rabbit: 250,
        pigeon: 240,
        lion: 430,
        frog: 55,
      ),
    ),
    RoundArray(
      whereToStop: 4,
      betBotChips: BetCountOnEach(
        swallow: 920,
        monkey: 610,
        eagle: 640,
        panda: 910,
        shark: 80,
        peacock: 530,
        rabbit: 880,
        pigeon: 920,
        lion: 550,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 650,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 220,
        peacock: 1020,
        rabbit: 550,
        pigeon: 1040,
        lion: 530,
        frog: 80,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 1020,
        monkey: 810,
        eagle: 1240,
        panda: 1110,
        shark: 120,
        peacock: 1120,
        rabbit: 1080,
        pigeon: 820,
        lion: 1550,
        frog: 40,
      ),
      increment: BetCountOnEach(
        swallow: 450,
        monkey: 460,
        eagle: 250,
        panda: 685,
        shark: 50,
        peacock: 720,
        rabbit: 150,
        pigeon: 140,
        lion: 980,
        frog: 30,
      ),
    ),
    RoundArray(
      whereToStop: 1,
      betBotChips: BetCountOnEach(
        swallow: 620,
        monkey: 610,
        eagle: 1540,
        panda: 810,
        shark: 80,
        peacock: 1230,
        rabbit: 850,
        pigeon: 620,
        lion: 550,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 420,
        eagle: 250,
        panda: 985,
        shark: 40,
        peacock: 520,
        rabbit: 350,
        pigeon: 640,
        lion: 530,
        frog: 60,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 2120,
        monkey: 2210,
        eagle: 2240,
        panda: 2410,
        shark: 60,
        peacock: 1620,
        rabbit: 1980,
        pigeon: 1220,
        lion: 2450,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 355,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 350,
        pigeon: 320,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 2,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 2240,
        panda: 1410,
        shark: 80,
        peacock: 1220,
        rabbit: 1780,
        pigeon: 1520,
        lion: 2050,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 205,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 250,
        pigeon: 620,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 6,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 2240,
        panda: 1410,
        shark: 80,
        peacock: 1220,
        rabbit: 2580,
        pigeon: 1520,
        lion: 2050,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 205,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 350,
        pigeon: 620,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 6,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 210,
        eagle: 2240,
        panda: 1410,
        shark: 80,
        peacock: 1220,
        rabbit: 1180,
        pigeon: 2520,
        lion: 2050,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 460,
        monkey: 520,
        eagle: 205,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 250,
        pigeon: 320,
        lion: 380,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 9,
      betBotChips: BetCountOnEach(
        swallow: 120,
        monkey: 210,
        eagle: 2240,
        panda: 1610,
        shark: 80,
        peacock: 2220,
        rabbit: 180,
        pigeon: 2520,
        lion: 3050,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 460,
        monkey: 520,
        eagle: 205,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 250,
        pigeon: 320,
        lion: 580,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 7,
      betBotChips: BetCountOnEach(
        swallow: 820,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1620,
        lion: 2050,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 1240,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 0,
      betBotChips: BetCountOnEach(
        swallow: 520,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1620,
        lion: 2050,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 350,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 1240,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 0,
      betBotChips: BetCountOnEach(
        swallow: 620,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1220,
        lion: 1150,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 450,
        monkey: 320,
        eagle: 250,
        panda: 685,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 140,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 0,
      betBotChips: BetCountOnEach(
        swallow: 2520,
        monkey: 1810,
        eagle: 3640,
        panda: 1110,
        shark: 20,
        peacock: 3520,
        rabbit: 2680,
        pigeon: 1120,
        lion: 3550,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 860,
        monkey: 220,
        eagle: 440,
        panda: 320,
        shark: 60,
        peacock: 520,
        rabbit: 460,
        pigeon: 220,
        lion: 640,
        frog: 80,
      ),
    ),
    RoundArray(
      whereToStop: 5,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 1840,
        panda: 610,
        shark: 30,
        peacock: 2220,
        rabbit: 1680,
        pigeon: 1520,
        lion: 2550,
        frog: 40,
      ),
      increment: BetCountOnEach(
        swallow: 660,
        monkey: 220,
        eagle: 340,
        panda: 420,
        shark: 80,
        peacock: 920,
        rabbit: 560,
        pigeon: 320,
        lion: 450,
        frog: 60,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 2520,
        monkey: 2210,
        eagle: 2240,
        panda: 1110,
        shark: 60,
        peacock: 1620,
        rabbit: 1980,
        pigeon: 1220,
        lion: 2450,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 355,
        panda: 425,
        shark: 100,
        peacock: 420,
        rabbit: 350,
        pigeon: 320,
        lion: 550,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 7,
      betBotChips: BetCountOnEach(
        swallow: 820,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1620,
        lion: 2050,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 1240,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 0,
      betBotChips: BetCountOnEach(
        swallow: 620,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1220,
        lion: 1150,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 450,
        monkey: 320,
        eagle: 250,
        panda: 685,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 140,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 8,
      betBotChips: BetCountOnEach(
        swallow: 1020,
        monkey: 810,
        eagle: 1240,
        panda: 1110,
        shark: 120,
        peacock: 1120,
        rabbit: 1080,
        pigeon: 820,
        lion: 1550,
        frog: 40,
      ),
      increment: BetCountOnEach(
        swallow: 450,
        monkey: 460,
        eagle: 250,
        panda: 685,
        shark: 50,
        peacock: 720,
        rabbit: 150,
        pigeon: 140,
        lion: 980,
        frog: 30,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 2120,
        monkey: 2210,
        eagle: 2240,
        panda: 2410,
        shark: 60,
        peacock: 1620,
        rabbit: 1980,
        pigeon: 1220,
        lion: 2450,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 355,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 350,
        pigeon: 320,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 5,
      betBotChips: BetCountOnEach(
        swallow: 520,
        monkey: 610,
        eagle: 1040,
        panda: 910,
        shark: 80,
        peacock: 1630,
        rabbit: 880,
        pigeon: 920,
        lion: 550,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 40,
        peacock: 1020,
        rabbit: 550,
        pigeon: 1040,
        lion: 530,
        frog: 60,
      ),
    ),
    RoundArray(
      whereToStop: 2,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 2240,
        panda: 1410,
        shark: 80,
        peacock: 1220,
        rabbit: 1780,
        pigeon: 1520,
        lion: 2050,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 205,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 250,
        pigeon: 620,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 4,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 240,
        panda: 810,
        shark: 150,
        peacock: 1220,
        rabbit: 3080,
        pigeon: 1020,
        lion: 2050,
        frog: 80,
      ),
      increment: BetCountOnEach(
        swallow: 850,
        monkey: 420,
        eagle: 450,
        panda: 325,
        shark: 100,
        peacock: 1120,
        rabbit: 850,
        pigeon: 240,
        lion: 630,
        frog: 10,
      ),
    ),
    RoundArray(
      whereToStop: 7,
      betBotChips: BetCountOnEach(
        swallow: 820,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1620,
        lion: 2050,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 1240,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 0,
      betBotChips: BetCountOnEach(
        swallow: 520,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1620,
        lion: 2050,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 350,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 1240,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 4,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 240,
        panda: 810,
        shark: 150,
        peacock: 1220,
        rabbit: 3080,
        pigeon: 1020,
        lion: 2050,
        frog: 80,
      ),
      increment: BetCountOnEach(
        swallow: 850,
        monkey: 420,
        eagle: 450,
        panda: 325,
        shark: 100,
        peacock: 1120,
        rabbit: 850,
        pigeon: 240,
        lion: 630,
        frog: 10,
      ),
    ),
    RoundArray(
      whereToStop: 7,
      betBotChips: BetCountOnEach(
        swallow: 820,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1620,
        lion: 2050,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 1240,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 8,
      betBotChips: BetCountOnEach(
        swallow: 1020,
        monkey: 810,
        eagle: 1240,
        panda: 1110,
        shark: 120,
        peacock: 1120,
        rabbit: 1080,
        pigeon: 820,
        lion: 1550,
        frog: 40,
      ),
      increment: BetCountOnEach(
        swallow: 450,
        monkey: 460,
        eagle: 250,
        panda: 685,
        shark: 50,
        peacock: 720,
        rabbit: 150,
        pigeon: 140,
        lion: 980,
        frog: 30,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 2120,
        monkey: 2210,
        eagle: 2240,
        panda: 2410,
        shark: 60,
        peacock: 1620,
        rabbit: 1980,
        pigeon: 1220,
        lion: 2450,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 355,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 350,
        pigeon: 320,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 2120,
        monkey: 2210,
        eagle: 2040,
        panda: 1110,
        shark: 150,
        peacock: 1620,
        rabbit: 1980,
        pigeon: 1220,
        lion: 1150,
        frog: 200,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 355,
        panda: 585,
        shark: 80,
        peacock: 220,
        rabbit: 350,
        pigeon: 320,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 1020,
        monkey: 810,
        eagle: 1240,
        panda: 1110,
        shark: 120,
        peacock: 1120,
        rabbit: 1080,
        pigeon: 820,
        lion: 1550,
        frog: 40,
      ),
      increment: BetCountOnEach(
        swallow: 450,
        monkey: 460,
        eagle: 250,
        panda: 685,
        shark: 50,
        peacock: 720,
        rabbit: 150,
        pigeon: 140,
        lion: 980,
        frog: 30,
      ),
    ),
    RoundArray(
      whereToStop: 1,
      betBotChips: BetCountOnEach(
        swallow: 620,
        monkey: 610,
        eagle: 1540,
        panda: 810,
        shark: 80,
        peacock: 1230,
        rabbit: 850,
        pigeon: 620,
        lion: 550,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 420,
        eagle: 250,
        panda: 985,
        shark: 40,
        peacock: 520,
        rabbit: 350,
        pigeon: 640,
        lion: 530,
        frog: 60,
      ),
    ),
    RoundArray(
      whereToStop: 1,
      betBotChips: BetCountOnEach(
        swallow: 5220,
        monkey: 3210,
        eagle: 2340,
        panda: 4210,
        shark: 60,
        peacock: 4720,
        rabbit: 2980,
        pigeon: 1520,
        lion: 1950,
        frog: 20,
      ),
      increment: BetCountOnEach(
        swallow: 1960,
        monkey: 1520,
        eagle: 1840,
        panda: 1920,
        shark: 120,
        peacock: 1920,
        rabbit: 1960,
        pigeon: 1920,
        lion: 1840,
        frog: 120,
      ),
    ),
    RoundArray(
      whereToStop: 0,
      betBotChips: BetCountOnEach(
        swallow: 2520,
        monkey: 1810,
        eagle: 3640,
        panda: 1110,
        shark: 20,
        peacock: 3520,
        rabbit: 2680,
        pigeon: 1120,
        lion: 3550,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 860,
        monkey: 220,
        eagle: 440,
        panda: 320,
        shark: 60,
        peacock: 520,
        rabbit: 460,
        pigeon: 220,
        lion: 640,
        frog: 80,
      ),
    ),
    RoundArray(
      whereToStop: 5,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 1840,
        panda: 610,
        shark: 30,
        peacock: 2220,
        rabbit: 1680,
        pigeon: 1520,
        lion: 2550,
        frog: 40,
      ),
      increment: BetCountOnEach(
        swallow: 660,
        monkey: 220,
        eagle: 340,
        panda: 420,
        shark: 80,
        peacock: 920,
        rabbit: 560,
        pigeon: 320,
        lion: 450,
        frog: 60,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 2520,
        monkey: 2210,
        eagle: 2240,
        panda: 1110,
        shark: 60,
        peacock: 1620,
        rabbit: 1980,
        pigeon: 1220,
        lion: 2450,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 355,
        panda: 425,
        shark: 100,
        peacock: 420,
        rabbit: 350,
        pigeon: 320,
        lion: 550,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 2120,
        monkey: 2210,
        eagle: 2240,
        panda: 2510,
        shark: 60,
        peacock: 1620,
        rabbit: 1980,
        pigeon: 1220,
        lion: 2450,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 355,
        panda: 625,
        shark: 80,
        peacock: 420,
        rabbit: 350,
        pigeon: 320,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 6,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 240,
        panda: 810,
        shark: 100,
        peacock: 1220,
        rabbit: 3080,
        pigeon: 1020,
        lion: 2050,
        frog: 80,
      ),
      increment: BetCountOnEach(
        swallow: 860,
        monkey: 420,
        eagle: 455,
        panda: 325,
        shark: 100,
        peacock: 520,
        rabbit: 850,
        pigeon: 220,
        lion: 650,
        frog: 80,
      ),
    ),
    RoundArray(
      whereToStop: 4,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 240,
        panda: 810,
        shark: 150,
        peacock: 1220,
        rabbit: 3080,
        pigeon: 1020,
        lion: 2050,
        frog: 80,
      ),
      increment: BetCountOnEach(
        swallow: 850,
        monkey: 420,
        eagle: 450,
        panda: 325,
        shark: 100,
        peacock: 1120,
        rabbit: 850,
        pigeon: 240,
        lion: 630,
        frog: 10,
      ),
    ),
    RoundArray(
      whereToStop: 0,
      betBotChips: BetCountOnEach(
        swallow: 520,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1620,
        lion: 2050,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 350,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 1240,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 0,
      betBotChips: BetCountOnEach(
        swallow: 620,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1220,
        lion: 1150,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 450,
        monkey: 320,
        eagle: 250,
        panda: 685,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 140,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 7,
      betBotChips: BetCountOnEach(
        swallow: 820,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1620,
        lion: 2050,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 1240,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 5,
      betBotChips: BetCountOnEach(
        swallow: 520,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 1230,
        rabbit: 880,
        pigeon: 920,
        lion: 550,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 40,
        peacock: 920,
        rabbit: 550,
        pigeon: 1240,
        lion: 530,
        frog: 60,
      ),
    ),
    RoundArray(
      whereToStop: 5,
      betBotChips: BetCountOnEach(
        swallow: 520,
        monkey: 610,
        eagle: 1040,
        panda: 910,
        shark: 80,
        peacock: 1630,
        rabbit: 880,
        pigeon: 920,
        lion: 550,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 40,
        peacock: 1020,
        rabbit: 550,
        pigeon: 1040,
        lion: 530,
        frog: 60,
      ),
    ),
    RoundArray(
      whereToStop: 8,
      betBotChips: BetCountOnEach(
        swallow: 1020,
        monkey: 810,
        eagle: 1240,
        panda: 1110,
        shark: 120,
        peacock: 1120,
        rabbit: 1080,
        pigeon: 820,
        lion: 1550,
        frog: 40,
      ),
      increment: BetCountOnEach(
        swallow: 450,
        monkey: 460,
        eagle: 250,
        panda: 685,
        shark: 50,
        peacock: 720,
        rabbit: 150,
        pigeon: 140,
        lion: 980,
        frog: 30,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 2120,
        monkey: 2210,
        eagle: 2240,
        panda: 2410,
        shark: 60,
        peacock: 1620,
        rabbit: 1980,
        pigeon: 1220,
        lion: 2450,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 355,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 350,
        pigeon: 320,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 2,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 2240,
        panda: 1410,
        shark: 80,
        peacock: 1220,
        rabbit: 1780,
        pigeon: 1520,
        lion: 2050,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 205,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 250,
        pigeon: 620,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 6,
      betBotChips: BetCountOnEach(
        swallow: 620,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 680,
        pigeon: 1220,
        lion: 1150,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 450,
        monkey: 320,
        eagle: 250,
        panda: 685,
        shark: 50,
        peacock: 720,
        rabbit: 450,
        pigeon: 140,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 1,
      betBotChips: BetCountOnEach(
        swallow: 620,
        monkey: 610,
        eagle: 1540,
        panda: 810,
        shark: 80,
        peacock: 1230,
        rabbit: 850,
        pigeon: 620,
        lion: 550,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 420,
        eagle: 250,
        panda: 985,
        shark: 40,
        peacock: 520,
        rabbit: 350,
        pigeon: 640,
        lion: 530,
        frog: 60,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 2120,
        monkey: 2210,
        eagle: 2240,
        panda: 2410,
        shark: 60,
        peacock: 1620,
        rabbit: 1980,
        pigeon: 1220,
        lion: 2450,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 355,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 350,
        pigeon: 320,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 2,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 2240,
        panda: 1410,
        shark: 80,
        peacock: 1220,
        rabbit: 1780,
        pigeon: 1520,
        lion: 2050,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 205,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 250,
        pigeon: 620,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 6,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 2240,
        panda: 1410,
        shark: 80,
        peacock: 1220,
        rabbit: 2580,
        pigeon: 1520,
        lion: 2050,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 205,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 350,
        pigeon: 620,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 6,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 210,
        eagle: 2240,
        panda: 1410,
        shark: 80,
        peacock: 1220,
        rabbit: 1180,
        pigeon: 2520,
        lion: 2050,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 460,
        monkey: 520,
        eagle: 205,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 250,
        pigeon: 320,
        lion: 380,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 4,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 240,
        panda: 810,
        shark: 150,
        peacock: 1220,
        rabbit: 3080,
        pigeon: 1020,
        lion: 2050,
        frog: 80,
      ),
      increment: BetCountOnEach(
        swallow: 850,
        monkey: 420,
        eagle: 450,
        panda: 325,
        shark: 100,
        peacock: 1120,
        rabbit: 850,
        pigeon: 240,
        lion: 630,
        frog: 10,
      ),
    ),
    RoundArray(
      whereToStop: 7,
      betBotChips: BetCountOnEach(
        swallow: 820,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1620,
        lion: 2050,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 1240,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 1,
      betBotChips: BetCountOnEach(
        swallow: 620,
        monkey: 1110,
        eagle: 1040,
        panda: 810,
        shark: 80,
        peacock: 1030,
        rabbit: 850,
        pigeon: 620,
        lion: 850,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 250,
        monkey: 550,
        eagle: 250,
        panda: 985,
        shark: 40,
        peacock: 320,
        rabbit: 250,
        pigeon: 240,
        lion: 430,
        frog: 55,
      ),
    ),
    RoundArray(
      whereToStop: 4,
      betBotChips: BetCountOnEach(
        swallow: 920,
        monkey: 610,
        eagle: 640,
        panda: 910,
        shark: 80,
        peacock: 530,
        rabbit: 880,
        pigeon: 920,
        lion: 550,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 650,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 220,
        peacock: 1020,
        rabbit: 550,
        pigeon: 1040,
        lion: 530,
        frog: 80,
      ),
    ),
    RoundArray(
      whereToStop: 0,
      betBotChips: BetCountOnEach(
        swallow: 620,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1220,
        lion: 1150,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 450,
        monkey: 320,
        eagle: 250,
        panda: 685,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 140,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 9,
      betBotChips: BetCountOnEach(
        swallow: 120,
        monkey: 210,
        eagle: 2240,
        panda: 1610,
        shark: 80,
        peacock: 2220,
        rabbit: 180,
        pigeon: 2520,
        lion: 3050,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 460,
        monkey: 520,
        eagle: 205,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 250,
        pigeon: 320,
        lion: 580,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 0,
      betBotChips: BetCountOnEach(
        swallow: 620,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1220,
        lion: 1150,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 450,
        monkey: 320,
        eagle: 250,
        panda: 685,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 140,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 0,
      betBotChips: BetCountOnEach(
        swallow: 2520,
        monkey: 1810,
        eagle: 3640,
        panda: 1110,
        shark: 20,
        peacock: 3520,
        rabbit: 2680,
        pigeon: 1120,
        lion: 3550,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 860,
        monkey: 220,
        eagle: 440,
        panda: 320,
        shark: 60,
        peacock: 520,
        rabbit: 460,
        pigeon: 220,
        lion: 640,
        frog: 80,
      ),
    ),
    RoundArray(
      whereToStop: 5,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 1840,
        panda: 610,
        shark: 30,
        peacock: 2220,
        rabbit: 1680,
        pigeon: 1520,
        lion: 2550,
        frog: 40,
      ),
      increment: BetCountOnEach(
        swallow: 660,
        monkey: 220,
        eagle: 340,
        panda: 420,
        shark: 80,
        peacock: 920,
        rabbit: 560,
        pigeon: 320,
        lion: 450,
        frog: 60,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 2520,
        monkey: 2210,
        eagle: 2240,
        panda: 1110,
        shark: 60,
        peacock: 1620,
        rabbit: 1980,
        pigeon: 1220,
        lion: 2450,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 355,
        panda: 425,
        shark: 100,
        peacock: 420,
        rabbit: 350,
        pigeon: 320,
        lion: 550,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 0,
      betBotChips: BetCountOnEach(
        swallow: 520,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1620,
        lion: 2050,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 350,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 1240,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 8,
      betBotChips: BetCountOnEach(
        swallow: 1020,
        monkey: 810,
        eagle: 1240,
        panda: 1110,
        shark: 120,
        peacock: 1120,
        rabbit: 1080,
        pigeon: 820,
        lion: 1550,
        frog: 40,
      ),
      increment: BetCountOnEach(
        swallow: 450,
        monkey: 460,
        eagle: 250,
        panda: 685,
        shark: 50,
        peacock: 720,
        rabbit: 150,
        pigeon: 140,
        lion: 980,
        frog: 30,
      ),
    ),
    RoundArray(
      whereToStop: 4,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 240,
        panda: 810,
        shark: 150,
        peacock: 1220,
        rabbit: 3080,
        pigeon: 1020,
        lion: 2050,
        frog: 80,
      ),
      increment: BetCountOnEach(
        swallow: 850,
        monkey: 420,
        eagle: 450,
        panda: 325,
        shark: 100,
        peacock: 1120,
        rabbit: 850,
        pigeon: 240,
        lion: 630,
        frog: 10,
      ),
    ),
    RoundArray(
      whereToStop: 7,
      betBotChips: BetCountOnEach(
        swallow: 820,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1620,
        lion: 2050,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 1240,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 0,
      betBotChips: BetCountOnEach(
        swallow: 520,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1620,
        lion: 2050,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 350,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 1240,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 2120,
        monkey: 2210,
        eagle: 2240,
        panda: 2410,
        shark: 60,
        peacock: 1620,
        rabbit: 1980,
        pigeon: 1220,
        lion: 2450,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 355,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 350,
        pigeon: 320,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 2120,
        monkey: 2210,
        eagle: 2040,
        panda: 1110,
        shark: 150,
        peacock: 1620,
        rabbit: 1980,
        pigeon: 1220,
        lion: 1150,
        frog: 200,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 355,
        panda: 585,
        shark: 80,
        peacock: 220,
        rabbit: 350,
        pigeon: 320,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 4,
      betBotChips: BetCountOnEach(
        swallow: 1020,
        monkey: 910,
        eagle: 240,
        panda: 810,
        shark: 150,
        peacock: 1220,
        rabbit: 2080,
        pigeon: 1020,
        lion: 2050,
        frog: 80,
      ),
      increment: BetCountOnEach(
        swallow: 450,
        monkey: 420,
        eagle: 450,
        panda: 325,
        shark: 120,
        peacock: 820,
        rabbit: 350,
        pigeon: 540,
        lion: 630,
        frog: 10,
      ),
    ),
    RoundArray(
      whereToStop: 4,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 240,
        panda: 810,
        shark: 150,
        peacock: 1220,
        rabbit: 3080,
        pigeon: 1020,
        lion: 2050,
        frog: 80,
      ),
      increment: BetCountOnEach(
        swallow: 850,
        monkey: 420,
        eagle: 450,
        panda: 325,
        shark: 100,
        peacock: 1120,
        rabbit: 850,
        pigeon: 240,
        lion: 630,
        frog: 10,
      ),
    ),
    RoundArray(
      whereToStop: 7,
      betBotChips: BetCountOnEach(
        swallow: 820,
        monkey: 610,
        eagle: 1240,
        panda: 910,
        shark: 80,
        peacock: 920,
        rabbit: 1180,
        pigeon: 1620,
        lion: 2050,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 50,
        peacock: 720,
        rabbit: 550,
        pigeon: 1240,
        lion: 530,
        frog: 20,
      ),
    ),
    RoundArray(
      whereToStop: 3,
      betBotChips: BetCountOnEach(
        swallow: 2120,
        monkey: 2210,
        eagle: 2240,
        panda: 2410,
        shark: 60,
        peacock: 1620,
        rabbit: 1980,
        pigeon: 1220,
        lion: 2450,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 355,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 350,
        pigeon: 320,
        lion: 350,
        frog: 50,
      ),
    ),
    RoundArray(
      whereToStop: 5,
      betBotChips: BetCountOnEach(
        swallow: 520,
        monkey: 610,
        eagle: 1040,
        panda: 910,
        shark: 80,
        peacock: 1630,
        rabbit: 880,
        pigeon: 920,
        lion: 550,
        frog: 60,
      ),
      increment: BetCountOnEach(
        swallow: 550,
        monkey: 320,
        eagle: 250,
        panda: 985,
        shark: 40,
        peacock: 1020,
        rabbit: 550,
        pigeon: 1040,
        lion: 530,
        frog: 60,
      ),
    ),
    RoundArray(
      whereToStop: 2,
      betBotChips: BetCountOnEach(
        swallow: 1120,
        monkey: 1210,
        eagle: 2240,
        panda: 1410,
        shark: 80,
        peacock: 1220,
        rabbit: 1780,
        pigeon: 1520,
        lion: 2050,
        frog: 50,
      ),
      increment: BetCountOnEach(
        swallow: 560,
        monkey: 320,
        eagle: 205,
        panda: 685,
        shark: 80,
        peacock: 420,
        rabbit: 250,
        pigeon: 620,
        lion: 350,
        frog: 50,
      ),
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    onlineUsersCountTimer != null && onlineUsersCountTimer!.isActive ? onlineUsersCountTimer!.cancel() : null;
    streams = [
      database.child(whereTOStopKey).onValue.listen((event) {
        debugPrint('EVENT.SNAPSHOT.VALUE: ${event.snapshot.value}');
        whereTOStopCount(event.snapshot.value.runtimeType == int ? event.snapshot.value as int : whereTOStopCount.value);
      }, onError: (error) {
        debugPrint('whereTOStop ERROR: $error');
        // Error.
      }),
    ];
    onlineUsersCountUpdateMathod();
    every15sec = Timer.periodic(const Duration(seconds: 30), (timer) {
      every1sec = Timer.periodic(const Duration(seconds: 1), (timer1Sec) {
        cycleNo(timer.tick);
        currentSec(timer1Sec.tick);
        /* debugPrint('TIMER1SEC.TICK: ${timer1Sec.tick}');
        debugPrint('timer.tick: ${timer.tick}'); */
        // database.update({"current_sec": timer1Sec.tick});
        if (timer1Sec.tick == 30) {
          debugPrint('new round starts here');
          database.update({currentEventKey: EventStatus.startBetting.name});
          timer1Sec.cancel();
        }
        if (timer1Sec.tick == 30 || (timer1Sec.tick >= 0 && timer1Sec.tick < 11)) {
          if (timer1Sec.tick == 30) {
            betCountOnEach = roundArray[cycleNo.value].betBotChips.obs;
            developer.log("${betCountOnEach.toJson()}");
          }
          betCountOnEach.value.swallow += roundArray[cycleNo.value].increment.swallow;
          betCountOnEach.value.monkey += roundArray[cycleNo.value].increment.monkey;
          betCountOnEach.value.eagle += roundArray[cycleNo.value].increment.eagle;
          betCountOnEach.value.panda += roundArray[cycleNo.value].increment.panda;
          if (timer1Sec.tick == 0 ||
              timer1Sec.tick == 2 ||
              timer1Sec.tick == 4 ||
              timer1Sec.tick == 5 ||
              timer1Sec.tick == 7 ||
              timer1Sec.tick == 9) {
            betCountOnEach.value.shark += roundArray[cycleNo.value].increment.shark;
          }
          betCountOnEach.value.peacock += roundArray[cycleNo.value].increment.peacock;
          betCountOnEach.value.rabbit += roundArray[cycleNo.value].increment.rabbit;
          betCountOnEach.value.pigeon += roundArray[cycleNo.value].increment.pigeon;
          betCountOnEach.value.lion += roundArray[cycleNo.value].increment.lion;
          if (timer1Sec.tick == 0 || timer1Sec.tick == 4 || timer1Sec.tick == 8) {
            betCountOnEach.value.frog += roundArray[cycleNo.value].increment.frog;
          }
          /* betCountOnEach = BetCountOnEach(
                swallow: betCountOnEach.swallow + betBotIncrementList[i][Random().nextInt(9)],
                monkey: betCountOnEach.monkey + betBotIncrementList[i][Random().nextInt(9)],
                eagle: betCountOnEach.eagle + betBotIncrementList[i][Random().nextInt(9)],
                panda: betCountOnEach.panda + betBotIncrementList[i][Random().nextInt(9)],
                shark: betCountOnEach.shark + betBotIncrementList[i][Random().nextInt(9)],
                peacock: betCountOnEach.peacock + betBotIncrementList[i][Random().nextInt(9)],
                rabbit: betCountOnEach.rabbit + betBotIncrementList[i][Random().nextInt(9)],
                pigeon: betCountOnEach.pigeon + betBotIncrementList[i][Random().nextInt(9)],
                lion: betCountOnEach.lion + betBotIncrementList[i][Random().nextInt(9)],
                frog: betCountOnEach.frog + betBotIncrementList[i][Random().nextInt(9)],
              ); */
          developer.log("${betCountOnEach.toJson()}");
          database.update({betBotChipsKey: betCountOnEach.toJson()});
        }
        if (timer1Sec.tick == 10) {
          Future.delayed(const Duration(milliseconds: 400), () {
            database.update({currentEventKey: EventStatus.stopBetting.name});
          });
        }
        if (timer1Sec.tick == 12) {
          isPlay(true);
          // whereTOStopCount = Random().nextInt(10).obs;
          /* if (cycleNo.value > 2 && cycleNo.value < 13) {
            whereTOStopCount = tempSeriesList[cycleNo.value - 3].obs;
          } else {
            whereTOStopCount = Random().nextInt(10).obs;
          } */
          whereTOStopCount = roundArray[cycleNo.value].whereToStop.obs;

          database.update({
            whereTOStopObjKey: {whereTOStopKey: whereTOStopCount.value, whereTOStopIndexKey: cycleNo.value}
          });
          Future.delayed(const Duration(seconds: 2), () {
            database.update({currentEventKey: EventStatus.startSpin.name});
          });
        }
        if (timer1Sec.tick == 22) {
          isPlay(false);
          database.update({currentEventKey: EventStatus.stopSpin.name});
          debugPrint('RESULT Time start');
          database.child(usersKey).get().then((event) {
            List<UserDataModel> allUserDataList = jsonDecode(jsonEncode(event.value)) != null
                ? List<UserDataModel>.from(jsonDecode(jsonEncode(event.value)).map((x) => UserDataModel.fromJson(x)))
                : [];
            for (var i = 0; i < allUserDataList.length; i++) {
              DataSnapshot? getRefOFPlayerElement;
              try {
                getRefOFPlayerElement =
                    event.children.where((element) => element.child(playerIdkey).value == allUserDataList[i].playerId).first;
              } catch (e) {
                getRefOFPlayerElement = null;
                debugPrint('event.children.where Error: $e');
              }
              int totalPlaceAmount = 0;
              List<SelectedItem> selectedItems = allUserDataList[i].selectedBetItems;

              if (selectedItems.isNotEmpty) {
                for (var j = 0; j < selectedItems.length; j++) {
                  totalPlaceAmount += selectedItems[j].selectedItemAmount;
                }
                int isWinOrNOtIndex = selectedItems.indexWhere((element) => element.selectedItemIndex == whereTOStopCount.value);
                debugPrint('ISWINORNOTINDEX: $isWinOrNOtIndex');
                debugPrint('${allUserDataList[i].playerId} TOTALPLACEAMOUNT: $totalPlaceAmount');
                if (isWinOrNOtIndex == -1) {
                  if (getRefOFPlayerElement != null) {
                    database.child(usersKey).child(getRefOFPlayerElement.key.toString()).update({
                      userCurrentBalanceKey: allUserDataList[i].userCurrentBalance - totalPlaceAmount,
                      afterWinOrLossAmountKey: "-$totalPlaceAmount"
                    });
                  }
                } else if (isWinOrNOtIndex > -1) {
                  if (getRefOFPlayerElement != null) {
                    int howManyX = getCoinValueWithX(selectedItems[isWinOrNOtIndex].selectedItemIndex);
                    debugPrint('+-+-+-+-+-+-+-+-+-+-+counter.VALUE: ${whereTOStopCount.value}');
                    debugPrint('+-+-+-+-+-+-+-+-+-+-+SELECTEDITEM index: ${selectedItems[isWinOrNOtIndex].selectedItemIndex}');
                    debugPrint('+-+-+-+-+-+-+-+-+-+-+SELECTEDITEM name: ${selectedItems[isWinOrNOtIndex].selectedItemName}');
                    debugPrint('+-+-+-+-+-+-+-+-+-+-+SELECTEDITEM Amount: ${selectedItems[isWinOrNOtIndex].selectedItemAmount}');
                    debugPrint('+-+-+-+-+-+-+-+-+-+-+HOWMANYX: $howManyX');
                    int howManyYouPutOnThat = selectedItems[isWinOrNOtIndex].selectedItemAmount;
                    int afterWinAmount =
                        ((howManyX * howManyYouPutOnThat) - (howManyX * howManyYouPutOnThat * 0.05) - totalPlaceAmount).round();
                    debugPrint('AFTERWINAMOUNT: $afterWinAmount');
                    database.child(usersKey).child(getRefOFPlayerElement.key.toString()).update({
                      userCurrentBalanceKey: allUserDataList[i].userCurrentBalance + afterWinAmount,
                      afterWinOrLossAmountKey: "+$afterWinAmount"
                    });
                  }
                }
              }
            }
          }, onError: (error) {
            debugPrint(' database.child(usersKey).get() ERROR: $error');
          });

          Future.delayed(const Duration(milliseconds: 700), () {
            database.update({currentEventKey: EventStatus.startResult.name});
          });
          /////================================================int Version======RecordList============================================
          database.child(last20RecordListKey).get().then((event) {
            if (event.children.isEmpty) {
              database.update({
                last20RecordListKey: [whereTOStopCount.value],
              });
              recordItemsList.insert(
                0,
                whereTOStopCount.value,
              );
            } else {
              debugPrint('+-+-+-last20RecordList EVENT.value: ${event.value}');
              debugPrint('+-+-+-last20RecordList LENGTH: ${recordItemsList.length}');
              if (recordItemsList.length == 20) {
                recordItemsList.removeAt(19);
              }
              recordItemsList.insert(
                0,
                whereTOStopCount.value,
              );
              database.update({last20RecordListKey: recordItemsList});
            }
          }, onError: (error) {
            debugPrint(' database.child(last20RecordList).get() ERROR: $error');
          });

          /////================================================Model Version======RecordList============================================

          /* database.child(last20RecordList).get().then((event) {
            if (event.children.isEmpty) {
              database.update({
                last20RecordList: [
                  RecordItem(
                    recordItemIndexByWheel: whereTOStopCount.value,
                    recordItemName: recordItemsPathList[whereTOStopCount.value].getBetItemNameValue(),
                    recordItemImgpath: recordItemsPathList[whereTOStopCount.value],
                  ).toJson()
                ],
              });
            } else {
              debugPrint('+-+-+-last20RecordList EVENT.value: ${event.value}');
              recordItemsList(jsonDecode(jsonEncode(event.value)) != null
                  ? List<RecordItem>.from(jsonDecode(jsonEncode(event.value)).map((x) => RecordItem.fromJson(x)))
                  : []);
              debugPrint('+-+-+-last20RecordList LENGTH: ${recordItemsList.length}');
              recordItemsList.insert(
                0,
                RecordItem(
                  recordItemIndexByWheel: whereTOStopCount.value,
                  recordItemName: recordItemsPathList[whereTOStopCount.value].getBetItemNameValue(),
                  recordItemImgpath: recordItemsPathList[whereTOStopCount.value],
                ),
              );
              List tempTojsonlist = [];
              for (var k = 0; k < recordItemsList.length; k++) {
                tempTojsonlist.add(recordItemsList[k].toJson());
              }
              database.update({last20RecordList: tempTojsonlist});
            }
          }, onError: (error) {
            debugPrint(' database.child(last20RecordList).get() ERROR: $error');
          }); */
        }
        if (timer1Sec.tick == 29) {
          if (userBettingStream != null) {
            userBettingStream!.cancel();
          }
          database.update({currentEventKey: EventStatus.stopResult.name});
          betCountOnEach.value = BetCountOnEach();
          debugPrint('RESULT Time over');
        }
      });
    });
  }

  void onlineUsersCountUpdateMathod() {
    onlineUsersCountTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      onlineUsersCount((Random().nextInt(50) + 100));
      database.update({onlineUsersCountKey: onlineUsersCount.value});
    });
  }

/*   int getCoinValueWithX(indexOFItem) {
    switch (indexOFItem) {
      case 0:
        return 6;
      case 1:
        return 8;
      case 2:
        return 12;
      case 3:
        return 8;
      case 4:
        return 24;
      case 5:
        return 8;
      case 6:
        return 6;
      case 7:
        return 8;
      case 8:
        return 12;
      case 9:
        return 50;
      default:
        return 0;
    }
  } */
  // wheelPartsTransSwallow 6x
// wheelPartsTransMonkey   8x
// wheelPartsTransEagle    12x
// wheelPartsTransPanda    8x
// wheelPartsTransShark    24x
// wheelPartsTransPeacock   8x
// wheelPartsTransRabbit   6x
// wheelPartsTransPigeon   8x
// wheelPartsTransLion   12x
// wheelPartsTransFrog   50x

  @override
  void onClose() {
    try {
      for (var it in streams) {
        it.cancel();
      }
    } catch (e) {
      debugPrint('E: $e');
    }
    try {
      every15sec.cancel();
    } catch (e) {
      debugPrint('E: $e');
    }
    try {
      every1sec.cancel();
    } catch (e) {
      debugPrint('E: $e');
    }
    onlineUsersCountTimer != null && onlineUsersCountTimer!.isActive ? onlineUsersCountTimer!.cancel() : null;
    super.onClose();
  }

  @override
  void dispose() {
    onlineUsersCountTimer != null && onlineUsersCountTimer!.isActive ? onlineUsersCountTimer!.cancel() : null;
    super.dispose();
  }
}
