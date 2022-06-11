import 'dart:io';
import 'package:hive/hive.dart';
import 'package:untitled1/src/aquarium.dart';
import 'package:untitled1/src/fish.dart';
import 'package:untitled1/src/model/fish_model.dart';

const String logBox = "logs_box";
const String fishBox = "fish_box";

main() {
  var path = Directory.current.path;
  Hive.init(path);
  Hive.registerAdapter<FishModel>(FishModelAdapter());
  Aquarium aquarium = Aquarium();
  aquarium.onStartPopulation();
}
