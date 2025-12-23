import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LaterScreen extends StatefulWidget {
  const LaterScreen({super.key});

  @override
  State<LaterScreen> createState() => _LaterScreenState();
}

class _LaterScreenState extends State<LaterScreen>
    with SingleTickerProviderStateMixin {
  bool showAddBox = false;
  final TextEditingController taskController = TextEditingController();
  List<Map<String, dynamic>> tasks = [];

  final supabase = Supabase.instance.client;

  Future<void> fetchTasks() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from('later_tasks')
        .select()
        .eq('status', 'in_progress')
        .order('created_at');

    setState(() {
      tasks = List<Map<String, dynamic>>.from(response);
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchTasks();
  //   fetchCompletedTasks();
  // }

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fetchTasks();
    fetchCompletedTasks();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.index == 2) {
        fetchCompletedTasks();
      }
    });
  }

  Future<void> addTask(String title) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from('later_tasks')
        .insert({'title': title, 'status': 'in_progress', 'user_id': user.id})
        .select()
        .single();

    setState(() {
      tasks.add(response);
      showAddBox = false;
    });
  }

  Future<void> completeTask(Map<String, dynamic> task) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase.from('completed_tasks').insert({
        'content': task['title'],
        'user_id': user.id,
        'completed_at': DateTime.now().toIso8601String(),
      });

      await supabase.from('later_tasks').delete().eq('id', task['id']);

      setState(() {
        tasks.removeWhere((t) => t['id'] == task['id']);
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error completing task')));
    }
  }

  List<Map<String, dynamic>> completedTasks = [];

  Future<void> fetchCompletedTasks() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final response = await supabase
          .from('completed_tasks')
          .select()
          .eq('user_id', user.id)
          .order('completed_at', ascending: false);

      setState(() {
        completedTasks = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching completed tasks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Later'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  showAddBox = !showAddBox;
                });
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'In Progress'),
              Tab(text: 'Archived'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildInProgress(),
            const Center(child: Text('Archived')),
            _buildCompletedTasksTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildInProgress() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (showAddBox) _buildAddTaskBox(),
          const SizedBox(height: 12),
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No tasks in progress yet!',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Tap the + button to add a new task',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return _buildTaskItem(tasks[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedTasksTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: completedTasks.isEmpty
          ? const Center(child: Text('No completed tasks yet'))
          : ListView.builder(
              itemCount: completedTasks.length,
              itemBuilder: (context, index) {
                final task = completedTasks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Icon(Icons.check, color: Colors.white),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Renad Emad Hamdy',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(task['content'] ?? 'No content'),
                        const SizedBox(height: 6),
                        Text(
                          task['completed_at'] != null
                              ? 'Completed at: ${DateTime.parse(task['completed_at']).toLocal().toString().substring(0, 16)}'
                              : 'Completed at: N/A',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildAddTaskBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          TextField(
            controller: taskController,
            decoration: const InputDecoration(
              hintText: 'Write a task...',
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  addTask(taskController.text.trim());
                  taskController.clear();
                }
              },

              child: const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildTaskItem(Map<String, dynamic> task) {
  //   return Card(
  //     margin: const EdgeInsets.only(bottom: 12),
  //     child: Padding(
  //       padding: const EdgeInsets.all(12),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               const CircleAvatar(
  //                 backgroundColor: Colors.pink,
  //                 child: Text('R', style: TextStyle(color: Colors.white)),
  //               ),
  //               const SizedBox(width: 8),
  //               const Text(
  //                 'Renad Emad Hamdy',
  //                 style: TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 6),
  //           Text(task['title']),
  //           const SizedBox(height: 12),
  //           Row(
  //             children: [
  //               ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Color(0xff03785b),
  //                 ),
  //                 onPressed: () {
  //                   completeTask(task['id']);
  //                 },

  //                 child: const Text(
  //                   'Complete',
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //               ),
  //               const SizedBox(width: 8),
  //               OutlinedButton(
  //                 onPressed: () {
  //                   completeTask(task['id']);
  //                 },
  //                 child: const Icon(Icons.alarm),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTaskItem(Map<String, dynamic> task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.pink,
                  child: Text('R', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Renad Emad Hamdy',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(task['title']),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff03785b),
                  ),
                  onPressed: () async {
                    await completeTask(task);

                    fetchCompletedTasks();
                  },

                  child: const Text(
                    'Complete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () async {
                    await completeTask(task);
                    setState(() {
                      completedTasks.insert(0, {
                        'content': task['title'],
                        'user_id': supabase.auth.currentUser!.id,
                        'completed_at': DateTime.now().toIso8601String(),
                      });
                    });
                  },
                  child: const Icon(Icons.alarm),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
