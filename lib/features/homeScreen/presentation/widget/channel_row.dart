import 'package:flutter/material.dart';
import 'package:slack_clone/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChannelsRow extends StatefulWidget {
  const ChannelsRow({super.key});

  @override
  State<ChannelsRow> createState() => _ChannelsRowState();
}

class _ChannelsRowState extends State<ChannelsRow> {
  List<Map<String, dynamic>> channels = [];
  bool isExpanded = false;
late RealtimeChannel channelsSubscription;

  @override
  void initState() {
    super.initState();
    fetchChannels();
    subscribeToChannels();
  }

  Future<void> fetchChannels() async {
    try {
      final response = await supabase.from('channels').select().order('created_at');
      setState(() {
        channels = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching channels: $e');
    }
  }

  void subscribeToChannels() {
  channelsSubscription = supabase
      .channel('public:channels')
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'channels',
        callback: (payload) {
          setState(() {
            channels.add(payload.newRecord);
          });
        },
      )
      .subscribe();
}
@override
void dispose() {
  supabase.removeChannel(channelsSubscription);
  super.dispose();
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

  Future<void> addChannelToSupabase(String name) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final response = await supabase.from('channels').insert({
        'name': name,
        'created_by': user.id,
        'created_at': DateTime.now().toIso8601String(),
      });
      // setState(() { channels.add(response[0]); });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding channel: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.tag_outlined),
                    SizedBox(width: 6),
                    Text(
                      'Channels',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: const Icon(Icons.arrow_drop_down, size: 24),
                ),
              ],
            ),
          ),
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: ConstrainedBox(
            constraints: isExpanded ? const BoxConstraints() : const BoxConstraints(maxHeight: 0),
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...channels.map((channel) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text('# ${channel['name']}'),
                      )),
                  TextButton.icon(
                    onPressed: showAddChannelDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Channel'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
