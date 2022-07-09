// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_product_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MerchantProductDBAdapter extends TypeAdapter<MerchantProductDB> {
  @override
  final int typeId = 9;

  @override
  MerchantProductDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MerchantProductDB(
      id: fields[0] as int?,
      name: fields[1] as String?,
      barcode: fields[2] as String?,
      currentPrice: fields[3] as String?,
      salePrice: fields[4] as String?,
      qty: fields[5] as String?,
      unitId: fields[6] as int?,
      unitName: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MerchantProductDB obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.barcode)
      ..writeByte(3)
      ..write(obj.currentPrice)
      ..writeByte(4)
      ..write(obj.salePrice)
      ..writeByte(5)
      ..write(obj.qty)
      ..writeByte(6)
      ..write(obj.unitId)
      ..writeByte(7)
      ..write(obj.unitName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MerchantProductDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
