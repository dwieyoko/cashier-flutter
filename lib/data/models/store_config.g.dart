// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoreConfigAdapter extends TypeAdapter<StoreConfig> {
  @override
  final int typeId = 3;

  @override
  StoreConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoreConfig(
      storeName: fields[0] as String,
      logoUrl: fields[1] as String?,
      primaryColorValue: fields[2] as int,
      secondaryColorValue: fields[3] as int,
      currencySymbol: fields[4] as String,
      currencyCode: fields[5] as String,
      taxRate: fields[6] as double,
      receiptFooter: fields[7] as String?,
      address: fields[8] as String?,
      phone: fields[9] as String?,
      enableDarkMode: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, StoreConfig obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.storeName)
      ..writeByte(1)
      ..write(obj.logoUrl)
      ..writeByte(2)
      ..write(obj.primaryColorValue)
      ..writeByte(3)
      ..write(obj.secondaryColorValue)
      ..writeByte(4)
      ..write(obj.currencySymbol)
      ..writeByte(5)
      ..write(obj.currencyCode)
      ..writeByte(6)
      ..write(obj.taxRate)
      ..writeByte(7)
      ..write(obj.receiptFooter)
      ..writeByte(8)
      ..write(obj.address)
      ..writeByte(9)
      ..write(obj.phone)
      ..writeByte(10)
      ..write(obj.enableDarkMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
