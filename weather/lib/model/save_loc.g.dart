// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_loc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaveLocAdapter extends TypeAdapter<SaveLoc> {
  @override
  final int typeId = 1;

  @override
  SaveLoc read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaveLoc(
      fields[1] as double,
      fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SaveLoc obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.lat)
      ..writeByte(2)
      ..write(obj.lon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaveLocAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
