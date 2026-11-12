import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:more_devs_do_zero/shared/analytics/app_analytics.dart';

class LoggedEvent {
  const LoggedEvent(this.name, this.parameters);

  final String name;
  final Map<String, Object> parameters;
}

// Registra os eventos em memória em vez de enviá-los ao Firebase.
class FakeAppAnalytics extends AppAnalytics {
  final List<LoggedEvent> events = [];

  List<String> get names => [for (final e in events) e.name];

  @override
  void send(
    String name,
    Map<String, Object> parameters,
    Future<void> Function(FirebaseAnalytics analytics) firebaseCall,
  ) {
    events.add(LoggedEvent(name, parameters));
  }
}
