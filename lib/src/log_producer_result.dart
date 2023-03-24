enum LogProducerResult {
  ok,
  invalid,
  writeError,
  dropError,
  sendNetworkError,
  sendQuotaError,
  sendUnauthorized,
  sendServerError,
  sendDiscardError,
  sendTimeError,
  sendExitBuffered,
  parametersInvalid,
  persistentError,
  unknown;

  static LogProducerResult fromInt(int code) {
    switch (code) {
      case 0:
        return LogProducerResult.ok;
      case 1:
        return LogProducerResult.invalid;
      case 2:
        return LogProducerResult.writeError;
      case 3:
        return LogProducerResult.dropError;
      case 4:
        return LogProducerResult.sendNetworkError;
      case 5:
        return LogProducerResult.sendQuotaError;
      case 6:
        return LogProducerResult.sendUnauthorized;
      case 7:
        return LogProducerResult.sendServerError;
      case 8:
        return LogProducerResult.sendDiscardError;
      case 9:
        return LogProducerResult.sendTimeError;
      case 10:
        return LogProducerResult.sendExitBuffered;
      case 11:
        return LogProducerResult.parametersInvalid;
      case 99:
        return LogProducerResult.persistentError;
      default:
        return LogProducerResult.unknown;
    }
  }
}
