import 'dart:async';
import 'dart:math';

import 'package:untitled1/src/actions/aquarium_action.dart';
import 'package:untitled1/src/actions/fish_actions.dart';
import 'package:untitled1/src/utils/fish_type.dart';
import 'package:untitled1/src/utils/utilits.dart';

class Fish with Utils implements FishActionInterface {


  final Random _random = Random.secure();
  AquariumActionInterface? aquariumAction;
  FishType? fishType;
  List<Timer> listTimer = [];

  String fishName = "";
  int? lifeTimeBegin = 0;
  int? lifeTimeEnd = 0;
  int actualLifeTime = 0;

  // Constructor of the class
  Fish(
      {this.fishType,
      required this.fishName,
      this.lifeTimeBegin,
      this.lifeTimeEnd,
      this.aquariumAction}) {
    actualLifeTime =
        _random.nextInt(lifeTimeEnd! - lifeTimeBegin!) + lifeTimeBegin!;
    onLive();
  }

  @override
  String getFishName() {
    return fishName;
  }

  @override
  bool getWilling() {
    var result = _random.nextBool();
    if (aquariumAction!.getAllFishSize() < 15) {
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
  onLive() {
    Timer(Duration(seconds: actualLifeTime), () => { onDead() });
    onChoose();
  }

  @override
  onChoose() {
    try {
      //Initial
      int chooseOpportunity = _random.nextInt(1) + 1;

      if (aquariumAction?.getAllFishSize() < 20) {
        chooseOpportunity = _random.nextInt(3) + 1;
      }

      for (int i = 0; i < chooseOpportunity; i++) {
        int chooseTime = _random.nextInt(actualLifeTime);
        Timer timer = Timer(Duration(seconds: chooseTime),
            () => {aquariumAction?.onChosenFish(fishType!, fishName)});
        listTimer.add(timer);
      }
    } on Exception catch (e) {
      print("Error: fish => onChoose => $e");
    }
  }

  @override
  onDead() {
    try {
      for (var element in listTimer) {
        element.cancel();
      }
      aquariumAction?.onDead(fishName, fishType!);
    } on Exception catch (e) {
      print("Error: fish => onDead => $e");
    }
  }

  @override
  String onGenerateNewName(String parentName) {
    int lengthGenerateName = parentName.length ~/ 2;
    return parentName + getRandomString(lengthGenerateName);
  }
}
