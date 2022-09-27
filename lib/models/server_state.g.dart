// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServerStateAdapter extends TypeAdapter<ServerState> {
  @override
  final int typeId = 2;

  @override
  ServerState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ServerState.external;
      case 1:
        return ServerState.local;
      default:
        return ServerState.external;
    }
  }

  @override
  void write(BinaryWriter writer, ServerState obj) {
    switch (obj) {
      case ServerState.external:
        writer.writeByte(0);
        break;
      case ServerState.local:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
