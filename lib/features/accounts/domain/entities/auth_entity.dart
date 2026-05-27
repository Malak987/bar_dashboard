import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String userId;
  final String userName;
  final String token;
  final String expiresAt;

  const AuthEntity({
    required this.userId,
    required this.userName,
    required this.token,
    required this.expiresAt,
  });

  @override
  List<Object?> get props => [userId, userName, token, expiresAt];
}
