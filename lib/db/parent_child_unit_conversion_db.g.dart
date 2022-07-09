// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_child_unit_conversion_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParentChildUnitDBAdapter extends TypeAdapter<ParentChildUnitDB> {
  @override
  final int typeId = 12;

  @override
  ParentChildUnitDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ParentChildUnitDB(
      id: fields[0] as int?,
      name: fields[1] as String?,
      description: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ParentChildUnitDB obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParentChildUnitDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
