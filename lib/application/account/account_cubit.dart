import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/x_user.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this.firestore) : super(AccountInitial());
  final FirebaseFirestore firestore;
  late final users = firestore.collection('users');
  late final usernames = firestore.collection('usernames');
  void createAccount(XUser user) async {
    emit(AccountStateLoading());

    try {
      var username = await usernames.doc(user.username).get();
      if (username.exists) return emit(AccountUserNameExists());
    } catch (_) {}
    try {
      await users.doc(user.uid).set(user.toMap(), SetOptions(merge: false));
      await usernames.doc(user.username).set({});
      return emit(AccountCreated());
    } on Exception catch (e) {
      debugPrint(e.toString());
      return emit(AccountCreateFailed());
    }
  }

  void checkHaveAccount(String uid) async {
    emit(AccountStateLoading());

    try {
      final user = await users.doc(uid).get();
      if (user.exists) {
        return emit(AccountExists(uid: uid));
      }
    } catch (_) {}
    return emit(AccountNotExists(uid: uid));
  }
}
