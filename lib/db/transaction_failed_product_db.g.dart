// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_failed_product_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionFailedProductDBAdapter
    extends TypeAdapter<TransactionFailedProductDB> {
  @override
  final int typeId = 8;

  @override
  TransactionFailedProductDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionFailedProductDB(
      idTransaction: fields[0] as String?,
      item: fields[1] as String?,
      itemName: fields[2] as String?,
      price: fields[3] as double?,
      quantity: fields[4] as double?,
      disc: fields[5] as int?,
      total: fields[6] as double?,
      productId: fields[7] as int?,
      unitId: fields[8] as int?,
      unitName: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionFailedProductDB obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.idTransaction)
      ..writeByte(1)
      ..write(obj.item)
      ..writeByte(2)
      ..write(obj.itemName)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.disc)
      ..writeByte(6)
      ..write(obj.total)
      ..writeByte(7)
      ..write(obj.productId)
      ..writeByte(8)
      ..write(obj.unitId)
      ..writeByte(9)
      ..write(obj.unitName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionFailedProductDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
