// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'units_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnitsModelAdapter extends TypeAdapter<UnitsModel> {
  @override
  final int typeId = 11;

  @override
  UnitsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnitsModel(
      id: fields[0] as int?,
      name: fields[1] as String?,
      description: fields[2] as String?,
      createdAt: fields[3] as String?,
      updatedAt: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UnitsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
