// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_failed_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionFailedDBAdapter extends TypeAdapter<TransactionFailedDB> {
  @override
  final int typeId = 7;

  @override
  TransactionFailedDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionFailedDB(
      id: fields[0] as String?,
      date: fields[1] as String?,
      productList: (fields[2] as List?)?.cast<TransactionFailedProductDB>(),
      status: fields[3] as String?,
      totalPriceTransaction: fields[4] as double?,
      totalPaymentCustomer: fields[5] as double?,
      totalMoneyChanges: fields[6] as double?,
      merchantId: fields[7] as int?,
      type: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionFailedDB obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.productList)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.totalPriceTransaction)
      ..writeByte(5)
      ..write(obj.totalPaymentCustomer)
      ..writeByte(6)
      ..write(obj.totalMoneyChanges)
      ..writeByte(7)
      ..write(obj.merchantId)
      ..writeByte(8)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionFailedDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
