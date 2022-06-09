import 'dart:async';
import 'package:untitled1/src/actions/aquarium_action.dart';

class Shark {

  final AquariumActionInterface? _actionInterface;

  Shark(this._actionInterface) {
    onLiveShark();
  }

  void onLiveShark() {
    int timeInterval = 10;
    if (_actionInterface?.getAllFishSize() > 30) timeInterval = 5;
    Timer(Duration(seconds: timeInterval), () => {
      if (_actionInterface?.getAllFishSize() > 20){
       selectFish()
      }
      else{
      onLiveShark()
      }
    });
  }

  void selectFish(){
    _actionInterface?.onSharkChooseFish();
    onLiveShark();
  }

}
