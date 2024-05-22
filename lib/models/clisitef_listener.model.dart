/// Abstract class representing a listener for CliSiTef events.
///
/// Implement this class to handle data and transaction result events.
abstract class CliSiTefListener {
  /// Handles incoming data from the CliSiTef.
  /// 
  /// Parameters:
  /// - `currentStage`: The current stage of the transaction, `1` for startTrasaction and `2` for finishTransaction.
  /// - `command`: The command received.
  /// - `fieldId`: The ID of the field.
  /// - `minLength`: The minimum length of the input.
  /// - `maxLength`: The maximum length of the input.
  /// - `input`: The input data received.
  void onData(
    int currentStage,
    int command,
    int fieldId,
    int minLength,
    int maxLength,
    String input,
  );

  /// Handles the result of a transaction from the CLI SiTef.
  /// 
  /// Parameters:
  /// - `currentStage`: The current stage of the transaction, `1` for startTrasaction and `2` for finishTransaction.
  /// - `resultCode`: The result code of the transaction.
  void onTransactionResult(
    int currentStage,
    int resultCode,
  );
}
