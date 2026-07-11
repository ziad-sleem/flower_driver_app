import 'package:equatable/equatable.dart';

class UsersEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;

  const UsersEntity({this.id, this.firstName, this.lastName, this.email});

  @override
  List<Object?> get props => [id, firstName, lastName, email];
}
