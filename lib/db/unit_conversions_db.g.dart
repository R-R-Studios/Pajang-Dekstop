// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_conversions_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnitConversionDBAdapter extends TypeAdapter<UnitConversionDB> {
  @override
  final int typeId = 11;

  @override
  UnitConversionDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnitConversionDB(
      id: fields[0] as int?,
      valueUnitParent: fields[1] as int?,
      valueUnitChild: fields[2] as int?,
      child: fields[3] as ParentChildUnitDB?,
      parent: fields[4] as ParentChildUnitDB?,
    );
  }

  @override
  void write(BinaryWriter writer, UnitConversionDB obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.valueUnitParent)
      ..writeByte(2)
      ..write(obj.valueUnitChild)
      ..writeByte(3)
      ..write(obj.child)
      ..writeByte(4)
      ..write(obj.parent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitConversionDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
