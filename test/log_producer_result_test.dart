import 'package:aliyun_log_dart_sdk/src/log_producer_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LogProducerResultTests', () {
    test('LogProducerResult', () async {
      expect(LogProducerResult.ok, intToLogProducerResult(0));
      expect(LogProducerResult.invalid, intToLogProducerResult(1));
      expect(LogProducerResult.writeError, intToLogProducerResult(2));
      expect(LogProducerResult.dropError, intToLogProducerResult(3));
      expect(LogProducerResult.sendNetworkError, intToLogProducerResult(4));
      expect(LogProducerResult.sendQuotaError, intToLogProducerResult(5));
      expect(LogProducerResult.sendUnauthorized, intToLogProducerResult(6));
      expect(LogProducerResult.sendServerError, intToLogProducerResult(7));
      expect(LogProducerResult.sendDiscardError, intToLogProducerResult(8));
      expect(LogProducerResult.sendTimeError, intToLogProducerResult(9));
      expect(LogProducerResult.sendExitBuffered, intToLogProducerResult(10));
      expect(LogProducerResult.parametersInvalid, intToLogProducerResult(11));
      expect(LogProducerResult.persistentError, intToLogProducerResult(99));
      expect(LogProducerResult.unknown, intToLogProducerResult(-1));
      expect(LogProducerResult.unknown, intToLogProducerResult(33));
    });
  });
}
