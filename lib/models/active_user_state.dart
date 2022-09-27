import 'package:hive/hive.dart';
part 'active_user_state.g.dart';

@HiveType(typeId: 3)
enum ActiveServerAuth {
  @HiveField(0)
  authorized,
  @HiveField(1)
  notAuthorised
}
