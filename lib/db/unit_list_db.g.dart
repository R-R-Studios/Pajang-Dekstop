// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_list_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnitListDBAdapter extends TypeAdapter<UnitListDB> {
  @override
  final int typeId = 6;

  @override
  UnitListDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnitListDB(
      id: fields[0] as int?,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UnitListDB obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitListDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
