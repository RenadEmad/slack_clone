// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:slack_clone/features/homeScreen/presentation/widget/nav_item.dart';
// import 'package:slack_clone/sharedConfig/routes/app_routes.dart';

// class MainLayout extends StatelessWidget {
//   const MainLayout({super.key, required this.child});

//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     final location = GoRouterState.of(context).uri.toString();

//     return Scaffold(
//       body: child, 
//       bottomNavigationBar: SafeArea(
//         top: false,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           color: Colors.white,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               NavItem(
//                 icon: Icons.home,
//                 label: 'Home',
//                 isActive: location == Routes.homeScreen,
//                 onTap: () => context.push(Routes.homeScreen),
//               ),

//               NavItem(
//                 icon: Icons.chat_bubble_outline,
//                 label: 'DMs',
//                 isActive: location == Routes.dmsScreen,
//                 onTap: () => context.push(Routes.dmsScreen),
//               ),
//               NavItem(
//                 icon: Icons.notifications_none,
//                 label: 'Activity',
//                 isActive: location == '/profile',
//                 onTap: () => context.go('/profile'),
//               ),
//               NavItem(
//                 icon: Icons.search,
//                 label: 'Search',
//                 isActive: location == '/profile',
//                 onTap: () => context.go('/profile'),
//               ),
//               NavItem(
//                 icon: Icons.more_horiz,
//                 label: 'More',
//                 isActive: location == '/profile',
//                 onTap: () => context.go('/profile'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
