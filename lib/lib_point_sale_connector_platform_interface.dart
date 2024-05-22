import 'package:lib_point_sale_connector/models/clisitef_listener.model.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'lib_point_sale_connector_method_channel.dart';

abstract class LibPointSaleConnectorPlatform extends PlatformInterface {
  /// Constructs a LibPointSaleConnectorPlatform.
  LibPointSaleConnectorPlatform() : super(token: _token);

  static final Object _token = Object();

  static LibPointSaleConnectorPlatform _instance =
      MethodChannelLibPointSaleConnector();

  /// The default instance of [LibPointSaleConnectorPlatform] to use.
  ///
  /// Defaults to [MethodChannelLibPointSaleConnector].
  static LibPointSaleConnectorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LibPointSaleConnectorPlatform] when
  /// they register themselves.
  static set instance(LibPointSaleConnectorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<int> init({
    required String storeCode,
    required String sitefAddress,
    required String terminalNumber,
    String additionalParams = '',
  }) {
    throw UnimplementedError('init() has not been implemented');
  }

  Future<int> startTransaction({
    required CliSiTefListener listener,
    required String paymentMethod,
    required String value,
    required String couponNbr,
    required String operatorId,
    required String restrictions,
  }) {
    throw UnimplementedError('startTransaction() has not been implemented');
  }

  Future<int> continueTransaction({
    required CliSiTefListener listener,
    required String input,
  }) {
    throw UnimplementedError('continueTransaction() has not been implemented');
  }

  Future<int> finishTransaction({
    required CliSiTefListener listener,
    required int confirm,
  }) {
    throw UnimplementedError('finishTransaction() has not been implemented');
  }

  Future<int> getQttPendingTransactions({
    required String taxInvoiceDate,
    required String taxInvoiceNumber,
  }) {
    throw UnimplementedError(
        'getQttPendingTransactions() hat not been implemented');
  }

  Future<bool> isPinpadPresent() {
    throw UnimplementedError('isPinpadPresent() has not been implemented');
  }

  Future<int> readYesNo(String message) {
    throw UnimplementedError('readYesNo() has not been implemented');
  }

  Future<int> submitPendingMessages() {
    throw UnimplementedError('submitPendingMessage() has not been implemented');
  }

  Future<int> setPinpadMessage({
    required String message,
    required bool persistent,
  }) {
    throw UnimplementedError('setPinpadMessage() has not been implemented');
  }

}
