import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:untitled1/src/actions/aquarium_action.dart';
import 'package:untitled1/src/actions/fish_actions.dart';
import 'package:untitled1/src/fish.dart';
import 'package:untitled1/src/shark.dart';
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

    Shark(this);

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
      FishActionInterface? chosenFishAction;
      String newFishName = "";
      String chosenFishName;

      chosenFishName = fishBList[_random.nextInt(getFishBSize())];

      if (type == FishType.fishB) {
        chosenFishName = fishAList[_random.nextInt(getFishASize())];
      }

      chosenFishAction = allFishList[chosenFishName];
      if (chosenFishAction?.getWilling()) {
        newFishName = getSpittedName(nameFish) +
            getSpittedName(chosenFishAction?.getFishName());
        findHowManyNewFishWillBeBorn(newFishName);
      }
    } on Exception catch (e) {
      print("Error: Aquarium => onChosenFish => $e");
    }
  }

  void findHowManyNewFishWillBeBorn(String newFishName) {
    try {
      var randomNewFishCount = _random.nextInt(2) + 1;
      if (getAllFishSize() > 20) {
        randomNewFishCount = _random.nextInt(1) + 1;
      }
      for (int i = 0; i < randomNewFishCount; i++) {
        generateNewFish(newFishName);
      }
    } on Exception catch (e) {
      print("Error: Aquarium => findHowManyNewFishWillBeBorn => $e");
    }
  }

  void generateNewFish(String newFishName) {
    FishType chosenFishType = getFishType();

    Fish newFish = Fish(
        fishType: chosenFishType,
        fishName: newFishName,
        lifeTimeBegin: getBeginningLiveTime(),
        lifeTimeEnd: lifeEndTime,
        aquariumAction: this,
        isParentName: true);

    if (chosenFishType == FishType.fishA) {
      fishAList.add(newFish.fishName);
    } else {
      fishBList.add(newFish.fishName);
    }
    allFishList[newFish.fishName] = newFish;
    onPrintHowManyFishOnTheAquarium(getFishASize(), getFishBSize());
  }

  @override
  onSharkChooseFish() {
    String chosenFishName;

    chosenFishName = fishBList[_random.nextInt(getFishBSize())];
    if (getFishType() == FishType.fishA) {
      chosenFishName = fishAList[_random.nextInt(getFishASize())];
    }

    if (getFishASize() > 20 && getFishASize() > getFishBSize()) {
      chosenFishName = fishAList[_random.nextInt(getFishASize())];
    }
    if (getFishBSize() > 20 && getFishBSize() > getFishASize()) {
      chosenFishName = fishBList[_random.nextInt(getFishBSize())];
    }

    var chosenFishAction = allFishList[chosenFishName];
    chosenFishAction?.onDead(byShark: true);
  }

  @override
  onDead({String? name, FishType? deadFishType, bool? isShark = false}) {
    try {
      String log = "time over";
      if (deadFishType == FishType.fishA) {
        fishAList.remove(name);
      } else {
        fishBList.remove(name);
      }
      allFishList.remove(name);
      countDeadFish++;
      if (isShark!) {
        log = "eaten by Shark";
      }
      onDeadPrintMessage(deadFishType!, name!, log, countDeadFish);
      onPrintHowManyFishOnTheAquarium(getFishASize(), getFishBSize());
    } on Exception catch (e) {
      print("Error: Aquarium => dead => $e");
    }
  }

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
