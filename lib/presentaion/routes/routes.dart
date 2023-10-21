import 'package:blackcoffer_assignment/domain/entity/post.dart';
import 'package:blackcoffer_assignment/presentaion/gps_permission_page.dart';
import 'package:blackcoffer_assignment/presentaion/video_record_page.dart';
import 'package:blackcoffer_assignment/presentaion/video_submit_page.dart';

import '../../application/auth/login_cubit.dart';
import '../create_profile_page.dart';
import '../home_page.dart';
import '../otp_page.dart';
import '../signin_phone.dart';
import 'package:go_router/go_router.dart';

final routes = GoRouter(initialLocation: '/login', routes: [
  GoRoute(
    path: SignInPage.path,
    builder: (context, state) => SignInPage(
      force: state.uri.hasFragment,
    ),
  ),
  GoRoute(
    path: OTPPage.path,
    builder: (context, state) {
      return OTPPage(confirmationResult: state.extra as XConfirmationResult);
    },
  ),
  GoRoute(
    path: CreateProfilePage.path,
    builder: (context, state) =>
        CreateProfilePage(userUid: state.extra as String),
  ),
  GoRoute(
    path: HomePage.path,
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: '/',
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: VideoRecordPage.path,
    builder: (context, state) => const VideoRecordPage(),
  ),
  GoRoute(
    path: GPSPermissionPage.path,
    builder: (context, state) => const GPSPermissionPage(),
  ),
  GoRoute(
    path: VideoSubmitPage.path,
    builder: (context, state) => VideoSubmitPage(post: state.extra as Post),
  ),
]);
