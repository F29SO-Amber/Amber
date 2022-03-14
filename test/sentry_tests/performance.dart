// import 'package:sentry/sentry.dart';

// final transaction = Sentry.startTransaction('processOrderBatch()', 'task');
// Future<void> main() async{try {
//   await processOrderBatch(transaction);
// } catch (exception) {
//   transaction.throwable = exception;
//   transaction.status = SpanStatus.internalError();
// } finally {
//   await transaction.finish();
// }}

// Future<void> processOrderBatch(ISentrySpan span) async {
//   // span operation: task, span description: operation
//   final innerSpan = span.startChild('task', description: 'operation');

//   try {
//     // omitted code
//   } catch (exception) {
//     innerSpan.throwable = exception;
//     innerSpan.status = SpanStatus.notFound();
//   } finally {
//     await innerSpan.finish();
//   }
// }
import 'package:amber/main.dart';
import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

 Future<void> main() async{SentryFlutter.init(
  (options) => {
    options.dsn = 'https://examplePublicKey@o0.ingest.sentry.io/0',
    // To set a uniform sample rate
    options.tracesSampleRate = 1.0,
    // OR if you prefer, determine traces sample rate based on the sampling context
    options.tracesSampler = (samplingContext) {
      // return a number between 0 and 1 or null (to fallback to configured value)
    },
  },
  appRunner: () => runApp(const MyApp()),
);}
