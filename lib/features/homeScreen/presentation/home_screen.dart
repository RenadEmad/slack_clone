import 'package:flutter/material.dart';
import 'package:slack_clone/core/constants/app_colors.dart';
import 'package:slack_clone/core/constants/app_text_style.dart';
import 'package:slack_clone/features/homeScreen/presentation/widget/app_floating_button.dart';
import 'package:slack_clone/features/homeScreen/presentation/widget/icon_tile.dart';
import 'package:slack_clone/features/homeScreen/presentation/widget/tagged_row.dart';
import 'package:slack_clone/features/homeScreen/presentation/widget/username_icon.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AppFloatingButton(onTap: () {}),
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Stack(
                children: [
                  UsernameIcon(text: 'Re'),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 10),
            ],
          ),
        ],
        backgroundColor: AppColors.splashBackgroundColor,
        leadingWidth: 400,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            children: [
              UsernameIcon(text: 'Ri'),

              const SizedBox(width: 8),
              Text(
                'Renad',
                style: AppTextTheme.lightTextTheme.headlineSmall!.copyWith(
                  color: Color.fromARGB(255, 65, 37, 27),
                  fontSize: 18,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: const Color.fromARGB(255, 65, 37, 27),
                ),
              ),
            ],
          ),
        ),
      ),

      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       SizedBox(height: 20),
      //       ListTile(
      //         leading: Icon(Icons.home),
      //         title: Text('Home'),
      //         onTap: () => Navigator.pop(context),
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.settings),
      //         title: Text('Settings'),
      //         onTap: () => Navigator.pop(context),
      //       ),
      //     ],
      //   ),
      // ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconTile(
                    icon: Icons.bookmark_outline_rounded,
                    title1: 'Later',
                    title2: '.items',
                    onTap: () {},
                  ),
                  IconTile(
                    icon: Icons.drafts_outlined,
                    title1: 'Drafts & Sent',
                    title2: '.drafts',
                    onTap: () {},
                  ),
                  IconTile(
                    icon: Icons.headset_outlined,
                    title1: 'Huddles',
                    title2: '.live',
                    onTap: () {},
                  ),
                  SizedBox(width: 12),
                  Container(
                    width: 70,
                    height: 70,
                    margin: EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 0.5),
                    ),
                    child: InkWell(
                      onTap: () {},
                      customBorder: CircleBorder(),
                      child: Center(
                        child: Icon(
                          Icons.settings,
                          size: 28,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12),
            Divider(color: Color(0xffcacaca), thickness: 0.5),
            SizedBox(height: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TaggedRow(
                  icon: Icons.tag_outlined,
                  text: 'Channels',
                  onTap: () {},
                  showDownArrow: true,
                ),
                SizedBox(height: 10),
                Divider(color: Color(0xffcacaca), thickness: 0.5),

                TaggedRow(
                  icon: Icons.chat_bubble_outline,
                  text: 'Direct messages',
                  onTap: () {},
                  showDownArrow: true,
                ),
                SizedBox(height: 10),
                Divider(color: Color(0xffcacaca), thickness: 0.5),

                TaggedRow(
                  icon: Icons.menu,
                  text: 'Recent apps',
                  onTap: () {},
                  showDownArrow: true,
                ),
                SizedBox(height: 10),
                Divider(color: Color(0xffcacaca), thickness: 0.5),

                TaggedRow(
                  icon: Icons.add,
                  text: 'Add teammates',
                  onTap: () {},
                  showDownArrow: false,
                ), 
              ],
            ),
          ],
        ),
      ),
    );
  }
}
