import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabase {
  RealtimeDatabase() {
    _ref = FirebaseDatabase.instance.ref();
  }

  late final DatabaseReference _ref;

  Future<void> add(String path, {required Map<String, dynamic> json}) async {
    return _ref.child(path).push().update(json);
  }

  Stream<Map<String, dynamic>?> onValue(String path) async* {
    yield* _ref.child(path).onValue.map(
      (event) {
        if (event.snapshot.exists) {
          return Map<String, dynamic>.from(
            event.snapshot.value! as Map<Object?, Object?>,
          );
        }
        return null;
      },
    );
  }
}

class RealtimeDatabasePath {
  static String get messages => 'messages/';
}
