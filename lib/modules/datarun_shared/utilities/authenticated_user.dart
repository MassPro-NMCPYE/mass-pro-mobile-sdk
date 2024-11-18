import 'package:d2_remote/modules/auth/user/entities/d_user.entity.dart';
import 'package:equatable/equatable.dart';

class AuthenticationResult with EquatableMixin {
  final bool success;
  final DUser? sessionUser;

  const AuthenticationResult({
    this.success = false,
    this.sessionUser,
  });

  AuthenticationResult copyWith({
    bool? success,
    DUser? sessionUser,
  }) {
    return AuthenticationResult(
      success: success ?? this.success,
      sessionUser: sessionUser ?? this.sessionUser,
    );
  }

  @override
  List<Object?> get props => [success, sessionUser];
}