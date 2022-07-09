// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileDBAdapter extends TypeAdapter<ProfileDB> {
  @override
  final int typeId = 10;

  @override
  ProfileDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileDB(
      userId: fields[0] as int?,
      userName: fields[1] as String?,
      merchantId: fields[2] as int?,
      merchantName: fields[3] as String?,
      phoneNumber: fields[4] as String?,
      email: fields[5] as String?,
      address: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileDB obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.merchantId)
      ..writeByte(3)
      ..write(obj.merchantName)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
