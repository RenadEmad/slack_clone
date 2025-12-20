import 'package:go_router/go_router.dart';
import 'package:slack_clone/features/Activity/presentation/view/activity_view_screen.dart';
import 'package:slack_clone/features/DMs/presentation/view/dms_view_screen.dart';
import 'package:slack_clone/features/homeScreen/presentation/view/chat_screen_view.dart';
import 'package:slack_clone/features/homeScreen/presentation/view/home_screen_view.dart';
import 'package:slack_clone/features/search/presentation/view/search_screen_view.dart';
import 'package:slack_clone/features/sign_in/presentation/view/chEmail/view/check_email_view.dart';
import 'package:slack_clone/features/sign_in/presentation/view/chNotification/view/check_notification_view.dart';
import 'package:slack_clone/features/sign_in/presentation/view/signup/view/sign_in_view.dart';
import 'package:slack_clone/features/splash_screen/view/splach_screen_view.dart';

class Routes {
  const Routes._();
  static const String splashScreen = '/splash-screen';
  static const String signup = '/signup';
  static const String checkEmail = '/check-email';
  static const String checkNotification = '/check-notification';
  static const String homeScreen = '/home-screen';
  static const String chatScreen = '/chat-screen';
  static const String dmsScreen = '/dms-screen';
  static const String activityScreen = '/activity-screen';
  static const String searchScreen = '/search-screen';
}

final appRouter = GoRouter(
  // initialLocation: Routes.splashScreen,
  initialLocation: Routes.homeScreen,
  routes: [
    GoRoute(
      path: Routes.splashScreen,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: Routes.signup,
      builder: (context, state) => const SignInView(),
    ),
    GoRoute(
      path: Routes.checkEmail,
      builder: (context, state) => const CheckEmailView(),
    ),
    GoRoute(
      path: Routes.checkNotification,
      builder: (context, state) => const CheckNotificationView(),
    ),
    GoRoute(
      path: Routes.homeScreen,
      builder: (context, state) => const HomeScreenView(),
    ),
    GoRoute(
      path: Routes.chatScreen,
      builder: (context, state) => const ChatScreenView(),
    ),
    GoRoute(
      path: Routes.dmsScreen,
      builder: (context, state) => const DmsScreenView(),
    ),
    GoRoute(
      path: Routes.activityScreen,
      builder: (context, state) => const ActivityScreenView(),
    ),
    GoRoute(
      path: Routes.searchScreen,
      builder: (context, state) => const SearchScreenView(),
    ),
  ],
);
