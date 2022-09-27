// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_user_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActiveServerAuthAdapter extends TypeAdapter<ActiveServerAuth> {
  @override
  final int typeId = 3;

  @override
  ActiveServerAuth read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ActiveServerAuth.authorized;
      case 1:
        return ActiveServerAuth.notAuthorised;
      default:
        return ActiveServerAuth.authorized;
    }
  }

  @override
  void write(BinaryWriter writer, ActiveServerAuth obj) {
    switch (obj) {
      case ActiveServerAuth.authorized:
        writer.writeByte(0);
        break;
      case ActiveServerAuth.notAuthorised:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActiveServerAuthAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
