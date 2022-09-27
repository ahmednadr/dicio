// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServerConfigAdapter extends TypeAdapter<ServerConfig> {
  @override
  final int typeId = 0;

  @override
  ServerConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServerConfig(
      fields[6] as String,
      fields[3] as String?,
    )
      ..users = (fields[0] as Map).cast<String, User>()
      ..state = fields[1] as ServerState
      ..userState = fields[2] as ActiveServerAuth
      ..deviceName = fields[4] as String?
      ..externalUrl = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, ServerConfig obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.users)
      ..writeByte(1)
      ..write(obj.state)
      ..writeByte(2)
      ..write(obj.userState)
      ..writeByte(3)
      ..write(obj.activeUser)
      ..writeByte(4)
      ..write(obj.deviceName)
      ..writeByte(5)
      ..write(obj.externalUrl)
      ..writeByte(6)
      ..write(obj.ip);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
