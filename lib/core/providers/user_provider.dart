import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import 'database_provider.dart';

final currentUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(appDatabaseProvider).watchFirstUser();
});
