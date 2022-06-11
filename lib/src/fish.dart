import 'dart:async';
import 'dart:math';

import 'package:hive/hive.dart';
import 'package:untitled1/src/actions/aquarium_action.dart';
import 'package:untitled1/src/actions/fish_actions.dart';
import 'package:untitled1/src/utils/fish_type.dart';
import 'package:untitled1/src/utils/utilits.dart';

class Fish implements FishActionInterface {
  final Random _random = Random.secure();
  List<Timer> listTimer = [];
  AquariumActionInterface aquariumAction;
  int lifeTimeBegin = 0;
  int lifeTimeEnd = 0;

  // @HiveField(0)
  String fishName;
  // @HiveField(1)
  DateTime dateTimeBirth;
  // @HiveField(2)
  int actualLifeTime;
  // @HiveField(3)
  FishType fishType;
  // @HiveField(4)
  String parentName;
  // @HiveField(5)
  int chooseOpportunity;
  // @HiveField(6)
  DateTime dateTimeDeath;
  // @HiveField(7)
  String deathReason;
  // @HiveField(8)
  List<Map> willHistory = [];

  Fish(
      {this.fishType,
      this.fishName,
      this.lifeTimeBegin,
      this.lifeTimeEnd,
      this.aquariumAction,
      this.parentName = ""}) {
    actualLifeTime =
        _random.nextInt(lifeTimeEnd - lifeTimeBegin) + lifeTimeBegin;

    dateTimeBirth = DateTime.now();

    if (parentName.isNotEmpty) {
      fishName = onGenerateNewName(fishName);
    }
    onLive();
  }

  @override
  onLive() {
    Timer timer = Timer(Duration(seconds: actualLifeTime), () => {onDead()});
    listTimer.add(timer);
    onChoose();
  }

  @override
  onChoose() {
    try {
      int lastTime = 0;
      chooseOpportunity = _random.nextInt(1) + 1;

      if (aquariumAction.getAllFishSize() < 20) {
        chooseOpportunity = _random.nextInt(2) + 1;
      }

      for (int i = 0; i < chooseOpportunity; i++) {
        int chooseTime = _random.nextInt(actualLifeTime);
        if (lastTime != chooseTime) {
          Timer timer = Timer(
              Duration(seconds: chooseTime),
              () => {
                    aquariumAction?.onChosenFish(fishType, fishName, chooseTime)
                  });
          listTimer.add(timer);
          lastTime = chooseTime;
        } else {
          i--;
          continue;
        }
      }
    } on Exception catch (e) {
      print("Error: fish => onChoose => $e");
    }
  }

  @override
  onDead({bool byShark = false}) {
    try {
      for (var element in listTimer) {
        element.cancel();
      }
      dateTimeDeath = DateTime.now();
      aquariumAction?.onDead(
          name: fishName, deadFishType: fishType, isShark: byShark);
    } on Exception catch (e) {
      print("Error: fish => onDead => $e");
    }
  }

  @override
  bool getWilling() {
    var result = _random.nextBool();
    if (aquariumAction.getAllFishSize() < 20) {
      result = true;
    }
    return result;
  }

  @override
  String onGenerateNewName(String parentName) {
    int lengthGenerateName = parentName.length ~/ 2;
    return parentName + getRandomString(lengthGenerateName);
  }

  @override
  String getFishName() {
    return fishName;
  }

  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) {
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
