import 'dart:async';
import 'package:untitled1/src/actions/aquarium_action.dart';

class Shark {
  final AquariumActionInterface _actionInterface;

  Shark(this._actionInterface) {
    onLiveShark();
  }

  void onLiveShark() {
    int timeInterval = 15;
    if (_actionInterface.getAllFishSize() > 30) timeInterval = 10;
    Timer(Duration(seconds: timeInterval), () => {selectFish()});
  }

  void selectFish() {
    if (_actionInterface.getAllFishSize() > 20) {
      _actionInterface?.onSharkChooseFish();
    }
    onLiveShark();
  }
}
