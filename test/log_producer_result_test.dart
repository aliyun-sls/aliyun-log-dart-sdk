import 'package:aliyun_log_dart_sdk/src/log_producer_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LogProducerResultTests', () {
    test('LogProducerResult', () async {
      expect(LogProducerResult.ok, LogProducerResult.fromInt(0));
      expect(LogProducerResult.invalid, LogProducerResult.fromInt(1));
      expect(LogProducerResult.writeError, LogProducerResult.fromInt(2));
      expect(LogProducerResult.dropError, LogProducerResult.fromInt(3));
      expect(LogProducerResult.sendNetworkError, LogProducerResult.fromInt(4));
      expect(LogProducerResult.sendQuotaError, LogProducerResult.fromInt(5));
      expect(LogProducerResult.sendUnauthorized, LogProducerResult.fromInt(6));
      expect(LogProducerResult.sendServerError, LogProducerResult.fromInt(7));
      expect(LogProducerResult.sendDiscardError, LogProducerResult.fromInt(8));
      expect(LogProducerResult.sendTimeError, LogProducerResult.fromInt(9));
      expect(LogProducerResult.sendExitBuffered, LogProducerResult.fromInt(10));
      expect(LogProducerResult.parametersInvalid, LogProducerResult.fromInt(11));
      expect(LogProducerResult.persistentError, LogProducerResult.fromInt(99));
      expect(LogProducerResult.unknown, LogProducerResult.fromInt(-1));
      expect(LogProducerResult.unknown, LogProducerResult.fromInt(33));
    });
  });
}
