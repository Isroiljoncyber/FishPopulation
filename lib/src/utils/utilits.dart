import 'dart:math';

import 'package:untitled1/src/utils/fish_type.dart';

mixin Utils {

  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) {
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  void onWillingPrintMessage(FishType type, bool isAccepted) {
    if (isAccepted) {
      if (type == FishType.fishA) {
        return print("WILLING: FishB => FishA is Accepted");
      }
      return print("WILLING: FishA => FishB is Accepted");
    }
    if (type == FishType.fishA) {
      return print("WILLING: FishB => FishA is Canceled");
    }
    return print("WILLING: FishA => FishB is Canceled");
  }

  void onLivePrintMessage(FishType type, String fishName) {
    return print("New Born : $type, Name is : $fishName ");
  }

  void onDeadPrintMessage(FishType type, String fishName, String reasonDeath) {
    return print(
        "New Dead: $type, Name was : $fishName , Death reason : $reasonDeath ");
  }

  void onPrintHowManyFishOnTheAquarium(int countFishA, int countFishB) {
    return print("Count FishA : $countFishA, Count FishB : $countFishB");
  }

  void onPrintWhenNoFishLeft(FishType type) {
    return print("PROGRAM OVER: \n There is no more Fish => FishType : $type");
  }
}
