import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:slack_clone/core/utils/models/schema.dart';
import 'package:slack_clone/main.dart';

late final PowerSyncDatabase db;

Future<String> getDatabasePath() async {
  final dir = await getApplicationSupportDirectory();
  return join(dir.path, 'powersync-demo.db');
}

bool isLoggedIn() {
  return Supabase.instance.client.auth.currentSession?.accessToken != null;
}

Future<void> openDatabase() async {
  db = PowerSyncDatabase(schema: schema, path: await getDatabasePath());
  await db.initialize();

  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  SupabaseConnector? currentConnector;

  if (isLoggedIn()) {
    currentConnector = SupabaseConnector(db);
    db.connect(connector: currentConnector);
  }

  Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
    final AuthChangeEvent event = data.event;

    if (event == AuthChangeEvent.signedIn) {
      currentConnector = SupabaseConnector(db);
      db.connect(connector: currentConnector!);
    } else if (event == AuthChangeEvent.signedOut) {
      currentConnector = null;
      await db.disconnect();
    } else if (event == AuthChangeEvent.tokenRefreshed) {
      currentConnector?.prefetchCredentials();
    }
  });
}

class SupabaseConnector extends PowerSyncBackendConnector {
  PowerSyncDatabase db;
  SupabaseConnector(this.db);

  @override
  Future<void> uploadData(PowerSyncDatabase database) {
    // TODO: implement uploadData
    throw UnimplementedError();
  }

  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      return null;
    }

    final token = session.accessToken;
    return PowerSyncCredentials(
      endpoint: 'https://6956ca2830605f245ffe929c.powersync.journeyapps.com',
      token: token,
    );
  }
}
