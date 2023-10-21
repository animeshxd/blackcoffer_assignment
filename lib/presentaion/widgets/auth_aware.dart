import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/account/account_cubit.dart';
import '../../application/auth/login_cubit.dart';
import '../create_profile_page.dart';
import '../home_page.dart';
import '../otp_page.dart';
import '../signin_phone.dart';

class AuthAware extends StatelessWidget {
  const AuthAware({
    super.key,
    required this.child,
    this.loginStateListener,
    this.accountStateListener,
  });
  final Widget child;
  final void Function(BuildContext context, LoginState state)?
      loginStateListener;
  final void Function(BuildContext context, AccountState state)?
      accountStateListener;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountCubit, AccountState>(
      listener: (context, state) {
        accountStateListener?.call(context, state);
        if (state is AccountNotExists) {
          goToCreateProfile(context, state.uid);
        }
        if (state is AccountExists || state is AccountCreated) {
          goToHomePage(context);
        }

      },
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          final messanger = ScaffoldMessenger.maybeOf(context);
          showSnackBar(String content) {
            messanger?.showSnackBar(SnackBar(content: Text(content)));
          }

          switch (state) {
            case LoginSuccessfull(user: var user):
              checkAccountExists(context, user.uid);
              break;
            case LoginRequired():
              goToLoginPage(context);
              break;
            case LoginOTPRequired(confirmationResult: var result):
              goToOtpPage(context, result);
              break;
            case LoginFailedConnection():
              showSnackBar('Connection Failed! Please check connecton');
              break;
            default:
          }
          loginStateListener?.call(context, state);
        },
        builder: (context, state) {
          if (state is LoginLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return child;
        },
      ),
    );
  }

  void goToHomePage(BuildContext context) => context.replace(HomePage.path);
  void goToCreateProfile(BuildContext context, String uid) {
    context.replace(CreateProfilePage.path, extra: uid);
  }

  void goToOtpPage(
    BuildContext context,
    XConfirmationResult confirmationResult,
  ) =>
      context.replace(OTPPage.path, extra: confirmationResult);

  void goToLoginPage(BuildContext context) =>
      context.replace(SignInPage.pathWithForced);

  void checkAccountExists(BuildContext context, String uid) {
    context.read<AccountCubit>().checkHaveAccount(uid);
  }
}
