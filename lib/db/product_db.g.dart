// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 1;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      item: fields[0] as String?,
      itemName: fields[1] as String?,
      price: fields[2] as double?,
      quantity: fields[3] as double?,
      disc: fields[4] as int?,
      total: fields[5] as double?,
      productId: fields[6] as int?,
      unitId: fields[7] as int?,
      unitName: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.item)
      ..writeByte(1)
      ..write(obj.itemName)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.disc)
      ..writeByte(5)
      ..write(obj.total)
      ..writeByte(6)
      ..write(obj.productId)
      ..writeByte(7)
      ..write(obj.unitId)
      ..writeByte(8)
      ..write(obj.unitName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
