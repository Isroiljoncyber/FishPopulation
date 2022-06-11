import 'package:hive/hive.dart';

part 'fish_model.g.dart';

@HiveType(typeId: 1)
class FishModel extends HiveObject {

  @HiveField(0)
  String fishName;
  @HiveField(1)
  DateTime dateTimeBirth;
  @HiveField(2)
  int actualLifeTime;
  @HiveField(3)
  String fishType;
  @HiveField(4)
  String parentName;
  @HiveField(5)
  int chooseOpportunity;
  @HiveField(6)
  DateTime dateTimeDeath;
  @HiveField(7)
  String deathReason;
  @HiveField(8)
  List<Map> willHistory = [];

  FishModel(
      {this.fishName,
      this.dateTimeBirth,
      this.actualLifeTime,
      this.fishType,
      this.parentName,
      this.chooseOpportunity,
      this.dateTimeDeath,
      this.deathReason,
      this.willHistory});
}