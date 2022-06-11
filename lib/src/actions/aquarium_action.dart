import 'package:untitled1/src/utils/fish_type.dart';

class AquariumActionInterface {

  onChosenFish(FishType type, String nameFish, int chosenTime) {}
  onDead({String name , FishType deadFishType, bool isShark}){}
  getAllFishSize(){}
  getFishASize() {}
  getFishBSize() {}
  getFishType(){}
  getSpittedName(String name){}
  onSharkChooseFish(){}

}
