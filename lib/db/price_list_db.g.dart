// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_list_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PriceListDBAdapter extends TypeAdapter<PriceListDB> {
  @override
  final int typeId = 5;

  @override
  PriceListDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PriceListDB(
      id: fields[0] as int?,
      salePrice: fields[1] as String?,
      unitList: fields[2] as UnitListDB?,
    );
  }

  @override
  void write(BinaryWriter writer, PriceListDB obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.salePrice)
      ..writeByte(2)
      ..write(obj.unitList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceListDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
