import 'dart:developer' as dev;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// Emits a log event using `dart:developer` [log()] method, and also
/// records the error and stack trace using [FirebaseCrashlytics].
///
/// If [shouldLogMessage] is `false`, the message will not be logged to
/// Firebase Crashlytics, only the error and stack trace.
///
/// If [error] is `null`, the error will not be recorded.
Future<void> log(
  String message, {
  bool shouldLogMessage = true,
  String name = '',
  Object? error,
  StackTrace? stackTrace,
}) async {
  dev.log(
    message,
    name: name,
    error: error,
    stackTrace: stackTrace,
  );

  if (shouldLogMessage) {
    dev.log('🔥 Logging message to Crashlytics... 🔥');
    await FirebaseCrashlytics.instance.log(message);
  }

  if (error == null) return; // If there's no error, don't record it.

  await FirebaseCrashlytics.instance.recordError(error, stackTrace);
}
