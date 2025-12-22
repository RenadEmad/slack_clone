import 'package:flutter/material.dart';
import 'package:slack_clone/core/constants/app_colors.dart';
import 'package:slack_clone/features/Activity/presentation/activity_screen.dart';
import 'package:slack_clone/features/DMs/presentation/dms_screen.dart';
import 'package:slack_clone/features/homeScreen/presentation/view/chat_screen_view.dart';
import 'package:slack_clone/features/homeScreen/presentation/widget/app_floating_button.dart';
import 'package:slack_clone/features/homeScreen/presentation/widget/channel_row.dart';
import 'package:slack_clone/features/homeScreen/presentation/widget/icon_tile.dart';
import 'package:slack_clone/features/homeScreen/presentation/widget/tagged_row.dart';
import 'package:slack_clone/features/homeScreen/presentation/widget/username_icon.dart';
import 'package:slack_clone/features/search/presentation/search_screen.dart';
import 'package:slack_clone/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  String username = '';
  bool isOnline = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    setUserOnlineStatus(true);
  }

  Future<void> setUserOnlineStatus(bool online) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase
          .from('profiles')
          .update({'is_online': online})
          .eq('user_id', user.id);
    } catch (e) {
      print('Error updating online status: $e');
    }
  }
  /*

@override
void dispose() {
  setUserOnlineStatus(false); 
  super.dispose();
}
 */

  // void subscribeToUserStatus() {
  //   final user = supabase.auth.currentUser;
  //   if (user == null) return;

  //   supabase
  //       .from('profiles:user_id=eq.${user.id}')
  //       .on(SupabaseEventTypes.update, (payload) {
  //         final updatedData = payload.newRecord;
  //         setState(() {
  //           isOnline = updatedData['is_online'] ?? false;
  //         });
  //       })
  //       .subscribe();
  // }

  Future<void> addChannelToSupabase(String name) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase.from('channels').insert({
        'name': name,
        'created_by': user.id,
        'created_at': DateTime.now().toIso8601String(),
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Channel "$name" added!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error adding channel: $e')));
    }
  }

  void showAddChannelDialog() {
    final TextEditingController channelController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Channel'),
        content: TextField(
          controller: channelController,
          decoration: InputDecoration(hintText: 'Channel name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = channelController.text.trim();
              if (name.isEmpty) return;

              await addChannelToSupabase(name);

              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> fetchUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('user_id', user.id)
          .single();

      setState(() {
        username = response['username'] ?? '';
        isOnline = response['is_online'] ?? false;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching profile: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<Widget> pages = [
      isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello, $username'),
                  Text('Status: ${isOnline ? "Online" : "Offline"}'),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
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
                        const SizedBox(width: 12),
                        Container(
                          width: 70,
                          height: 70,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey, width: 0.5),
                          ),
                          child: InkWell(
                            onTap: () {},
                            customBorder: const CircleBorder(),
                            child: const Center(
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
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xffcacaca), thickness: 0.5),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     ChannelsRow(),
                      const SizedBox(height: 10),
                      const Divider(color: Color(0xffcacaca), thickness: 0.5),
                      TaggedRow(
                        icon: Icons.chat_bubble_outline,
                        text: 'Direct messages',
                        onTap: () {},
                        showDownArrow: true,
                      ),
                      const SizedBox(height: 10),
                      const Divider(color: Color(0xffcacaca), thickness: 0.5),
                      TaggedRow(
                        icon: Icons.menu,
                        text: 'Recent apps',
                        onTap: () {},
                        showDownArrow: true,
                        children: const [
                          Text('General'),
                          Text('Random'),
                          Text('Flutter'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(color: Color(0xffcacaca), thickness: 0.5),
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
      const DmsScreen(),
      const ActivityScreen(),
      const SearchScreen(),

      Center(child: Text('More Page', style: theme.textTheme.headlineMedium)),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: AppFloatingButton(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatScreenView()),
          );
        },
      ),
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Stack(
                children: [
                  UsernameIcon(
                    text: username.isNotEmpty
                        ? username.substring(0, 2).toUpperCase()
                        : '??',
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isOnline ? Colors.green : Colors.grey,
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
          // child: Row(
          //   children: const [
          //     UsernameIcon(text: 'Ri'),
          //     SizedBox(width: 8),
          //     Text(
          //       'Renad',
          //       style: TextStyle(
          //         color: Color.fromARGB(255, 65, 37, 27),
          //         fontSize: 18,
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ),

      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Workspaces',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  TextButton(onPressed: () {}, child: Text('Edit')),
                ],
              ),
            ),
            Divider(thickness: 0.5),

            ListTile(
              leading: CircleAvatar(
                child: Text(
                  username.isNotEmpty ? username[0].toUpperCase() : '?',
                ),
              ),
              title: Text(username),
              subtitle: Text('Workspace'),
              onTap: () {},
            ),

            Divider(thickness: 0.5),

            SizedBox(height: 20),

            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add a workspace'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Preferences'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('Help'),
              onTap: () {},
            ),
          ],
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        indicatorColor: Colors.brown.withOpacity(0.7),
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.black45),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline, color: Colors.black45),
            label: 'DMs',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none, color: Colors.black45),
            label: 'Activity',
          ),
          NavigationDestination(
            icon: Icon(Icons.search, color: Colors.black45),
            label: 'Search',
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.more_horiz, color: Colors.black45),
          //   label: 'More',
          // ),
        ],
      ),

      body: pages[currentPageIndex],
    );
  }
}
