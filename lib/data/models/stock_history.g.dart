// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockHistoryAdapter extends TypeAdapter<StockHistory> {
  @override
  final int typeId = 4;

  @override
  StockHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockHistory(
      id: fields[0] as String,
      productId: fields[1] as String,
      productName: fields[2] as String,
      changeAmount: fields[3] as int,
      newQuantity: fields[4] as int,
      type: fields[5] as StockChangeType,
      reason: fields[6] as String?,
      timestamp: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StockHistory obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(3)
      ..write(obj.changeAmount)
      ..writeByte(4)
      ..write(obj.newQuantity)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.reason)
      ..writeByte(7)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StockChangeTypeAdapter extends TypeAdapter<StockChangeType> {
  @override
  final int typeId = 5;

  @override
  StockChangeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StockChangeType.sale;
      case 1:
        return StockChangeType.restock;
      case 2:
        return StockChangeType.adjustment;
      case 3:
        return StockChangeType.start;
      case 4:
        return StockChangeType.returned;
      default:
        return StockChangeType.sale;
    }
  }

  @override
  void write(BinaryWriter writer, StockChangeType obj) {
    switch (obj) {
      case StockChangeType.sale:
        writer.writeByte(0);
        break;
      case StockChangeType.restock:
        writer.writeByte(1);
        break;
      case StockChangeType.adjustment:
        writer.writeByte(2);
        break;
      case StockChangeType.start:
        writer.writeByte(3);
        break;
      case StockChangeType.returned:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockChangeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
