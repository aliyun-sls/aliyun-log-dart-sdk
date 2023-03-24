import 'package:aliyun_log_dart_sdk/aliyun_log_dart_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LogCallbackTests', () {
    test('LogCallback', () {
      callback(resultCode, errorMessage, logBytes, compressedBytes) {
        expect(LogProducerResult.ok, resultCode);
        expect('test', errorMessage);
        expect(14, logBytes);
        expect(235, compressedBytes);
      }

      callback(LogProducerResult.ok, 'test', 14, 235);
    });
  });
}
