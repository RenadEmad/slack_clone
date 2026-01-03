import 'package:powersync/powersync.dart';

const schema = Schema([
  Table('profiles', [
    Column.text('created_at'),
    Column.text('username'),
    Column.text('email'),
    Column.text('avatar_url'),
    Column.integer('is_online'),
    Column.text('user_id')
  ]),
  Table('messages', [
    Column.text('created_at'),
    Column.text('channel_id'),
    Column.text('sender_id'),
    Column.text('content')
  ])
]);
