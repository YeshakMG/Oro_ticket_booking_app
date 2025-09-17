import 'package:hive/hive.dart';

part 'trip_model.g.dart';

@HiveType(typeId: 1)
class TripModel extends HiveObject {
  @HiveField(0)
  String plateNumber;

  @HiveField(1)
  String level;

  @HiveField(2)
  String departure;

  @HiveField(3)
  String destination;

  @HiveField(4)
  int seatsAvailable;

  @HiveField(5)
  double price;

  TripModel({
    required this.plateNumber,
    required this.level,
    required this.departure,
    required this.destination,
    required this.seatsAvailable,
    required this.price,
  });
}
