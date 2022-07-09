// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelDBAdapter extends TypeAdapter<ProductModelDB> {
  @override
  final int typeId = 2;

  @override
  ProductModelDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModelDB(
      id: fields[0] as int?,
      name: fields[1] as String?,
      code: fields[2] as String?,
      barcode: fields[3] as String?,
      description: fields[4] as String?,
      createdAt: fields[5] as String?,
      stock: fields[6] as String?,
      originalPrice: fields[7] as String?,
      salePrice: fields[8] as String?,
      unitsId: fields[9] as int?,
      unitsName: fields[10] as String?,
      productId: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModelDB obj) {
    writer
      ..writeByte(12)
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
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.stock)
      ..writeByte(7)
      ..write(obj.originalPrice)
      ..writeByte(8)
      ..write(obj.salePrice)
      ..writeByte(9)
      ..write(obj.unitsId)
      ..writeByte(10)
      ..write(obj.unitsName)
      ..writeByte(11)
      ..write(obj.productId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
