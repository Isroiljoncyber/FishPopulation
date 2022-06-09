import 'dart:async';
import 'dart:math';

import 'package:untitled1/src/actions/aquarium_action.dart';
import 'package:untitled1/src/actions/fish_actions.dart';
import 'package:untitled1/src/utils/fish_type.dart';
import 'package:untitled1/src/utils/utilits.dart';

class Fish with Utils implements FishActionInterface {
  final Random _random = Random.secure();
  List<Timer> listTimer = [];

  AquariumActionInterface? aquariumAction;
  FishType? fishType;
  bool? isParentName;
  int? lifeTimeBegin = 0;
  int? lifeTimeEnd = 0;

  int actualLifeTime = 0;
  String fishName = "";
  DateTime? dateTimeBirth ;
  DateTime? dateTimeDeath ;

  Fish(
      {this.fishType,
      required this.fishName,
      this.lifeTimeBegin,
      this.lifeTimeEnd,
      this.aquariumAction,
      this.isParentName = false}) {

    actualLifeTime =
        _random.nextInt(lifeTimeEnd! - lifeTimeBegin!) + lifeTimeBegin!;

    dateTimeBirth = DateTime.now();

    if (isParentName!) {
      fishName = onGenerateNewName(fishName);
    }

    onLivePrintMessage(fishType!, fishName);

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
      int chooseOpportunity = _random.nextInt(1) + 1;

      if (aquariumAction?.getAllFishSize() < 20) {
        chooseOpportunity = _random.nextInt(2) + 1;
      }

      for (int i = 0; i < chooseOpportunity; i++) {
        int chooseTime = _random.nextInt(actualLifeTime);
        if (lastTime != chooseTime) {
          Timer timer = Timer(Duration(seconds: chooseTime),
              () => {aquariumAction?.onChosenFish(fishType!, fishName)});
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
  onDead({bool? byShark = false}) {
    try {
      for (var element in listTimer) {
        element.cancel();
      }
      dateTimeDeath = DateTime.now();
      aquariumAction?.onDead(
          name: fishName, deadFishType: fishType!, isShark: byShark);
    } on Exception catch (e) {
      print("Error: fish => onDead => $e");
    }
  }

  @override
  bool getWilling() {
    var result = _random.nextBool();
    if (aquariumAction!.getAllFishSize() < 20) {
      result = true;
    }
    if (result) {
      onWillingPrintMessage(fishType!, true);
      return result;
    }
    onWillingPrintMessage(fishType!, false);
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
}
