import 'dart:math';

import 'package:hive/hive.dart';
import 'package:untitled1/main.dart';
import 'package:untitled1/src/utils/fish_type.dart';
import 'package:untitled1/src/utils/hive_utils.dart';

class Utils with HiveUtils {

  List<String> logsList = [];

  void onWillingPrintMessage(FishType type, bool isAccepted) {
    if (isAccepted) {
      if (type == FishType.fishA) {
        return storeLogsToList("WILLING: FishB => FishA is Accepted");
      }
      return storeLogsToList("WILLING: FishA => FishB is Accepted");
    }
    if (type == FishType.fishA) {
      return storeLogsToList("WILLING: FishB => FishA is Canceled");
    }
    return storeLogsToList("WILLING: FishA => FishB is Canceled");
  }

  void onLivePrintMessage(FishType type, String fishName) {
    return storeLogsToList("Born : $type, name : $fishName ");
  }

  void onDeadPrintMessage(
      FishType type, String fishName, String reasonDeath, int deathCount) {
    return storeLogsToList(
        "Dead => : $type, name: $fishName, reason : $reasonDeath, all count : $deathCount");
  }

  void onPrintHowManyFishOnTheAquarium(int countFishA, int countFishB) {
    return storeLogsToList("FishA : $countFishA, FishB : $countFishB");
  }

  void onPrintWhenNoFishLeft(FishType type) {
    return storeLogsToList("PROGRAM OVER: \n There is no more Fish => FishType : $type");
  }

  void storeLogsToList(String log){
    logsList.add(log);
    if (logsList.length > 1000) {
      addAllBox(logBox, logsList);
      logsList.clear();
      log = " =============== Logs have been added to HIVE box recently =============";
    }
    print(log);
  }

}
