part of 'account_cubit.dart';
// enum AccountState {initial, loading, failed, created, exists, usernameExists, notFound }

sealed class AccountState extends Equatable {
  const AccountState();
  @override
  List<Object> get props => [];
}

final class AccountInitial extends AccountState {}

final class AccountStateLoading extends AccountState {}

final class AccountCreateFailed extends AccountState {}

final class AccountExists extends AccountState {
  final String uid;

  const AccountExists({required this.uid});
}

final class AccountNotExists extends AccountState {
  final String uid;
  const AccountNotExists({required this.uid});
}

final class AccountCreated extends AccountState {}

final class AccountUserNameExists extends AccountState {}
