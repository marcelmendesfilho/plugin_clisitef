import 'package:lib_point_sale_connector/models/clisitef_listener.model.dart';

import 'lib_point_sale_connector_platform_interface.dart';

/// Class responsible for interfacing with the Point of Sale (POS) system.
///
/// This class provides methods for initializing the POS connector, starting, continuing,
/// and finishing transactions, checking and submitting pending messages or transactions,
/// and managing the PIN pad.
class LibPointSaleConnector {
  /// Initializes the POS connector.
  ///
  /// Parameters:
  /// - `storeCode`: The code of the store.
  /// - `sitefAddress`: The address of the Sitef server.
  /// - `terminalNumber`: The terminal number.
  /// - `additionalParams`: Additional parameters (optional, check CliSiTef full documentation for more info).
  Future<int> init({
    required String storeCode,
    required String sitefAddress,
    required String terminalNumber,
    String additionalParams = '',
  }) {
    return LibPointSaleConnectorPlatform.instance.init(
      storeCode: storeCode,
      sitefAddress: sitefAddress,
      terminalNumber: terminalNumber,
      additionalParams: additionalParams,
    );
  }

  /// Starts a Sitef transaction.
  ///
  /// Parameters:
  /// - `listener`: The listener containing the onData and onTransactionResult methods that will handle the information.
  /// - `paymentMethod`: The payment method (check the CliSiTef full documentation for more info).
  /// - `value`: The transaction value.
  /// - `couponNbr`: The coupon number.
  /// - `operatorId`: The operator ID.
  /// - `restrictions`: The restrictions for the transaction (check the CliSiTef full documentation for more info).
  Future<int> startTransaction({
    required CliSiTefListener listener,
    required String paymentMethod,
    required String value,
    required String couponNbr,
    required String operatorId,
    required String restrictions,
  }) {
    return LibPointSaleConnectorPlatform.instance.startTransaction(
      listener: listener,
      paymentMethod: paymentMethod,
      value: value,
      couponNbr: couponNbr,
      operatorId: operatorId,
      restrictions: restrictions,
    );
  }

  /// Continues a transaction.
  /// 
  /// Parameters:
  /// - `listener`: The listener containing the onData and onTransactionResult methods that will handle the information.
  /// - `input`: The input or buffer for continuing the transaction, if you are not handling any commands or fields, the input shoul be an empty string.
  Future<int> continueTransaction({
    required CliSiTefListener listener,
    required String input,
  }) {
    return LibPointSaleConnectorPlatform.instance
        .continueTransaction(listener: listener, input: input);
  }

  /// Finishes a transaction.
  /// 
  /// Parameters:
  /// - `listener`: The listener containing the onData and onTransactionResult methods that will handle the information.
  /// - `confirm`: Confirmation value, `1` for confirmation and `0` for chargeback.
  Future<int> finishTransaction({
    required CliSiTefListener listener,
    required int confirm,
  }) {
    return LibPointSaleConnectorPlatform.instance
        .finishTransaction(listener: listener, confirm: confirm);
  }

  /// Gets the quantity of pending transactions.
  /// 
  /// Parameters:
  /// - `taxInvoiceDate`: The tax invoice date.
  /// - `taxInvoiceNumber`: The tax invoice number.
  Future<int> getQttPendingTransactions({
    required String taxInvoiceDate,
    required String taxInvoiceNumber,
  }) {
    return LibPointSaleConnectorPlatform.instance.getQttPendingTransactions(
      taxInvoiceDate: taxInvoiceDate,
      taxInvoiceNumber: taxInvoiceNumber,
    );
  }

  /// Submits pending messages.
  Future<int> submitPendingMessages() {
    return LibPointSaleConnectorPlatform.instance.submitPendingMessages();
  }

  /// Checks pin pad connection.
  Future<bool> isPinpadPresent() {
    return LibPointSaleConnectorPlatform.instance.isPinpadPresent();
  }

  /// Reads a yes or no answer for the given message on the pin pad.
  /// 
  /// Parameters:
  /// - `message`: The message to be displayed.
  Future<int> readYesNo(String message) {
    return LibPointSaleConnectorPlatform.instance.readYesNo(message);
  }

  /// Sets a pin pad message.
  /// 
  /// Parameters:
  /// - `message`: The message to be displayed.
  /// - `persistent`: Whether the message should be persistent.
  Future<int> setPinpadMessage({
    required String message,
    required bool persistent,
  }) {
    return LibPointSaleConnectorPlatform.instance
        .setPinpadMessage(message: message, persistent: persistent);
  }
}

/// Enum representing different CliSiTef commands that should be handled on the onData method of the listener.
enum CliSiTefCommand {
  resultData(value: 0),
  showMsgCashier(value: 1),
  showMsgCustomer(value: 2),
  showMsgCashierCustomer(value: 3),
  showMenuTitle(value: 4),
  clearMsgCashier(value: 11),
  clearMsgCustomer(value: 12),
  clearMsgCashierCustomer(value: 13),
  clearMenuTitle(value: 14),
  showHeader(value: 15),
  clearHeader(value: 16),
  askConfirmation(value: 20),
  getMenuOption(value: 21),
  pressAnyKey(value: 22),
  abortRequest(value: 23),
  getInternalField(value: 29),
  getField(value: 30),
  getCheckField(value: 31),
  getTrackField(value: 32),
  getPasswordField(value: 33),
  getCurrencyField(value: 34),
  getBarcodeField(value: 35),
  getPinpadConfirmation(value: 37),
  getMaskedField(value: 41),
  showQrCodeField(value: 50),
  removeQrCodeField(value: 51),
  messageQrCode(value: 52);

  const CliSiTefCommand({
    required this.value,
  });

  final int value;
}