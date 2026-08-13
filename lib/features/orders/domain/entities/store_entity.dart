import 'package:equatable/equatable.dart';

class StoreEntity extends Equatable {
  final String? name;
  final String? image;
  final String? address;
  final String? phoneNumber;
  final String? lat;
  final String? long;

  const StoreEntity({
    this.name,
    this.image,
    this.address,
    this.phoneNumber,
    this.lat,
    this.long,
  });

  @override
  List<Object?> get props => [name, image, address, phoneNumber, lat, long];
}
