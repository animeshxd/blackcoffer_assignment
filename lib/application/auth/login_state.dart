part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginFailedConnection extends LoginState {}

final class LoginOTPRequired extends LoginState {
  final XConfirmationResult confirmationResult;

  const LoginOTPRequired(this.confirmationResult);
}

final class OtpVerificationFailed extends LoginState {
  final XConfirmationResult confirmationResult;

  const OtpVerificationFailed(this.confirmationResult);
}

final class LoginSuccessfull extends LoginState {
  final User user;

  const LoginSuccessfull({required this.user});
}

final class LoginRequired extends LoginState {}
