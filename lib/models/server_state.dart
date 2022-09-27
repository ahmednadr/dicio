import 'package:hive/hive.dart';
part 'server_state.g.dart';

@HiveType(typeId: 2)
enum ServerState {
  @HiveField(0)
  external,
  @HiveField(1)
  local
}
