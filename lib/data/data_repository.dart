import 'package:chatbox/data/db.dart';

class DataRepository {
  DataRepository({
    required RealtimeDatabase database,
  }) : _database = database;

  final RealtimeDatabase _database;

  Future<void> send(String message) async {
    final path = RealtimeDatabasePath.messages;
    _database.add(path, json: {
      'text': message,
      'date': DateTime.now().toIso8601String(),
    });
  }

  Stream<List<String>> onMessages() async* {
    final path = RealtimeDatabasePath.messages;

    yield* _database.onValue(path).map((json) {
      final entries = json?.entries ?? [];

      final data = entries
          .map(
            (e) => e.value as Map<Object?, Object?>,
          )
          .toList();

      data.sort(
        (a, b) => DateTime.tryParse((b['date'] as String))!
            .compareTo(DateTime.tryParse(a['date'] as String)!),
      );

      return data.map((e) => e['text'] as String).toList();
    });
  }
}
