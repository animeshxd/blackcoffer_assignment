import 'package:go_router/go_router.dart';

import '../../application/auth/login_cubit.dart';
import '../../domain/entity/post/firebase_post.dart';
import '../../domain/entity/post/post.dart';
import '../create_profile_page.dart';
import '../gps_permission_page.dart';
import '../home_page.dart';
import '../otp_page.dart';
import '../signin_phone.dart';
import '../video_player_page.dart';
import '../video_posted_succesfully.dart';
import '../video_record_page.dart';
import '../video_submit_page.dart';

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
    builder: (context, state) => HomePage(
      params: state.extra == null
          ? const HomePageParams()
          : (state.extra as HomePageParams),
    ),
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
  GoRoute(
    path: VideoPostedSuccesfullPage.path,
    builder: (context, state) => const VideoPostedSuccesfullPage(),
  ),
  GoRoute(
    path: VideoPlayerPage.path,
    builder: (context, state) => VideoPlayerPage(post: state.extra as FPost),
  ),
]);
