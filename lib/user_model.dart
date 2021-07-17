import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 11)
class UserModel {
  @HiveField(0)
  String name;

  @HiveField(1)
  String college;

  UserModel({this.name = "", this.college = ""});
}
