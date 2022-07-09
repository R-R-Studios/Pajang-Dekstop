// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_receivings_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductReceivingsDBAdapter extends TypeAdapter<ProductReceivingsDB> {
  @override
  final int typeId = 4;

  @override
  ProductReceivingsDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductReceivingsDB(
      id: fields[0] as int?,
      name: fields[1] as String?,
      code: fields[2] as String?,
      barcode: fields[3] as String?,
      description: fields[4] as String?,
      priceList: (fields[5] as List?)?.cast<PriceListDB>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductReceivingsDB obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.barcode)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.priceList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductReceivingsDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
