import 'dart:io';
import 'dart:math';

import 'package:untitled1/src/actions/aquarium_action.dart';
import 'package:untitled1/src/actions/fish_actions.dart';
import 'package:untitled1/src/fish.dart';
import 'package:untitled1/src/utils/fish_type.dart';
import 'package:untitled1/src/utils/utilits.dart';

class Aquarium with Utils implements AquariumActionInterface {
  final Random _random = Random.secure();
  final int lifeEndTime = 60;

  Map<String, FishActionInterface> allFishList = {};
  List<String> fishAList = [];
  List<String> fishBList = [];
  int countDeadFish = 0;

  onStartPopulation() {
    Fish fishA = Fish(
        fishType: FishType.fishA,
        fishName: "fishAx",
        lifeTimeBegin: getBeginningLiveTime(),
        lifeTimeEnd: lifeEndTime,
        aquariumAction: this);

    Fish fishB = Fish(
        fishType: FishType.fishB,
        fishName: "fishBy",
        lifeTimeBegin: getBeginningLiveTime(),
        lifeTimeEnd: lifeEndTime,
        aquariumAction: this);

    allFishList[fishA.fishName] = fishA;
    allFishList[fishB.fishName] = fishB;

    fishAList.add(fishA.fishName);
    fishBList.add(fishB.fishName);

    onPrintHowManyFishOnTheAquarium(getFishASize(), getFishBSize());
  }

  @override
  int getAllFishSize() {
    return allFishList.length;
  }

  @override
  int getFishASize() {
    if (fishAList.isEmpty) {
      onPrintWhenNoFishLeft(FishType.fishA);
      exit(0);
    }
    return fishAList.length;
  }

  @override
  int getFishBSize() {
    if (fishBList.isEmpty) {
      onPrintWhenNoFishLeft(FishType.fishB);
      exit(0);
    }
    return fishBList.length;
  }

  @override
  onChosenFish(FishType type, String nameFish) {
    try {
      // random fish type bo`lishi kerak
      String newFishName = "";
      if (type == FishType.fishA) {
        var randomFishBName = fishBList[_random.nextInt(getFishBSize())];
        var fishBAction = allFishList[randomFishBName];
        if (fishBAction?.getWilling()) {
          String parentName = getSpittedName(nameFish) +
              getSpittedName(fishBAction?.getFishName());
          newFishName = fishBAction?.onGenerateNewName(parentName);
        }
      } else {
        // FishB ni yaratish
        var randomFishAName = fishAList[_random.nextInt(getFishASize())];
        var fishAAction = allFishList[randomFishAName];
        if (fishAAction?.getWilling()) {
          String parentName = getSpittedName(nameFish) +
              getSpittedName(fishAAction?.getFishName());
          newFishName = fishAAction?.onGenerateNewName(parentName);
        }
      }
      generateNewFish(newFishName);
      onPrintHowManyFishOnTheAquarium(getFishASize(), getFishBSize());
    } on Exception catch (e) {
      print("Error: Aquarium => onChosenFish => $e");
    }
  }

  void generateNewFish(String newFishName) {
    if (getFishType() == FishType.fishA) {
      Fish newFishA = Fish(
          fishType: FishType.fishA,
          fishName: newFishName,
          lifeTimeBegin: getBeginningLiveTime(),
          lifeTimeEnd: lifeEndTime,
          aquariumAction: this);
      allFishList[newFishA.fishName] = newFishA;
      fishAList.add(newFishName);
      onLivePrintMessage(FishType.fishA, newFishName);
    } else {
      Fish newFishB = Fish(
          fishType: FishType.fishB,
          fishName: newFishName,
          lifeTimeBegin: getBeginningLiveTime(),
          lifeTimeEnd: lifeEndTime,
          aquariumAction: this);
      allFishList[newFishB.fishName] = newFishB;
      fishBList.add(newFishName);
      onLivePrintMessage(FishType.fishB, newFishName);
    }
  }

  @override
  onDead(String? name, FishType deadFishType) {
    try {
      if (deadFishType == FishType.fishA) {
        fishAList.remove(name);
      } else {
        fishBList.remove(name);
      }
      allFishList.remove(name);
      onDeadPrintMessage(deadFishType, name!, "time over");
      onPrintHowManyFishOnTheAquarium(getFishASize(), getFishBSize());
    } on Exception catch (e) {
      print("Error: Aquarium => dead => $e");
    }
  }

  @override
  showProcessOfPopulation() {}

  @override
  FishType getFishType() {
    var result = _random.nextBool();
    if (result) {
      return FishType.fishA;
    }
    return FishType.fishB;
  }

  @override
  String getSpittedName(String name) {
    int startPoint = ((name.length) ~/ 3) * 2;
    return name.substring(startPoint, name.length);
  }

  int getBeginningLiveTime() {
    if (getAllFishSize() > 20) {
      return 10;
    }
    return 30;
  }
}
