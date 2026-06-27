import 'package:equatable/equatable.dart';

class ResetPasswordResponseEntity extends Equatable {
  final String message;
  final String token;

  const ResetPasswordResponseEntity({
    required this.message,
    required this.token,
  });

  @override
  List<Object?> get props => [message, token];
}
