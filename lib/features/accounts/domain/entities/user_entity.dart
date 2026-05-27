import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? address;
  final bool isArchived;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.address,
    required this.isArchived,
  });

  @override
  List<Object?> get props =>
      [id, name, email, phoneNumber, address, isArchived];
}
