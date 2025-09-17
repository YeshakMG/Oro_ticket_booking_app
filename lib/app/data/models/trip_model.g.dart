// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripModelAdapter extends TypeAdapter<TripModel> {
  @override
  final int typeId = 1;

  @override
  TripModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripModel(
      plateNumber: fields[0] as String,
      level: fields[1] as String,
      departure: fields[2] as String,
      destination: fields[3] as String,
      seatsAvailable: fields[4] as int,
      price: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TripModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.plateNumber)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.departure)
      ..writeByte(3)
      ..write(obj.destination)
      ..writeByte(4)
      ..write(obj.seatsAvailable)
      ..writeByte(5)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
