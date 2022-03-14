import 'package:amber/main.dart';
import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://956355f4458d402b8f9b84c565e1c2ad@o1166846.ingest.sentry.io/6257447';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );


  // or define SENTRY_DSN via Dart environment variable (--dart-define)
}  
