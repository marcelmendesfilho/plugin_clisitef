import 'package:flutter_test/flutter_test.dart';
import 'package:lib_point_sale_connector/lib_point_sale_connector.dart';
import 'package:lib_point_sale_connector/lib_point_sale_connector_platform_interface.dart';
import 'package:lib_point_sale_connector/lib_point_sale_connector_method_channel.dart';
import 'package:lib_point_sale_connector/models/clisitef_listener.model.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'lib_point_sale_connector_method_channel_test.dart';

class MockLibPointSaleConnectorPlatform
    with MockPlatformInterfaceMixin
    implements LibPointSaleConnectorPlatform {
  @override
  Future<int> init({
    required String storeCode,
    required String sitefAddress,
    required String terminalNumber,
    String additionalParams = '',
  }) =>
      Future.value(0);

  @override
  Future<int> startTransaction({
    required CliSiTefListener listener,
    required String paymentMethod,
    required String value,
    required String couponNbr,
    required String operatorId,
    required String restrictions,
  }) =>
      Future.value(0);

  @override
  Future<int> continueTransaction({
    required CliSiTefListener listener,
    required String input,
  }) =>
      Future.value(0);

  @override
  Future<int> finishTransaction({
    required CliSiTefListener listener,
    required int confirm,
  }) =>
      Future.value(0);

  @override
  Future<int> getQttPendingTransactions({
    required String taxInvoiceDate,
    required String taxInvoiceNumber,
  }) =>
      Future.value(0);

  @override
  Future<int> submitPendingMessages() => Future.value(0);

  @override
  Future<bool> isPinpadPresent() => Future.value(true);

  @override
  Future<int> readYesNo(String message) => Future.value(0);

  @override
  Future<int> setPinpadMessage({
    required String message,
    required bool persistent,
  }) =>
      Future.value(0);
}

void main() {
  final LibPointSaleConnectorPlatform initialPlatform =
      LibPointSaleConnectorPlatform.instance;

  test('$MethodChannelLibPointSaleConnector is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLibPointSaleConnector>());
  });

  test('init', () async {
    LibPointSaleConnector libPointSaleConnector = LibPointSaleConnector();
    MockLibPointSaleConnectorPlatform fakePlatform =
        MockLibPointSaleConnectorPlatform();
    LibPointSaleConnectorPlatform.instance = fakePlatform;

    expect(
      await libPointSaleConnector.init(
        storeCode: '00000000',
        sitefAddress: '192.168.0.91:4096',
        terminalNumber: 'MP000000',
        additionalParams:
            '[TipoPinPad=ANDROID_BT;PinPad.MAC=C8:36:A3:0B:C9:34;ParmsClient=1=00000000000000;]',
      ),
      0,
    );
  });

  test('startTransaction', () async {
    LibPointSaleConnector libPointSaleConnector = LibPointSaleConnector();
    MockLibPointSaleConnectorPlatform fakePlatform =
        MockLibPointSaleConnectorPlatform();
    LibPointSaleConnectorPlatform.instance = fakePlatform;

    expect(
      await libPointSaleConnector.startTransaction(
        listener: MockCliSiTefListener(),
        paymentMethod: '2',
        value: '50',
        couponNbr: '123456',
        operatorId: '1',
        restrictions: '',
      ),
      0,
    );
  });

   test('continueTransaction', () async {
    LibPointSaleConnector libPointSaleConnector = LibPointSaleConnector();
    MockLibPointSaleConnectorPlatform fakePlatform =
        MockLibPointSaleConnectorPlatform();
    LibPointSaleConnectorPlatform.instance = fakePlatform;

    expect(
      await libPointSaleConnector.continueTransaction(
        listener: MockCliSiTefListener(),
        input: '',
      ),
      0,
    );
  });

  test('finishTransaction', () async {
    LibPointSaleConnector libPointSaleConnector = LibPointSaleConnector();
    MockLibPointSaleConnectorPlatform fakePlatform =
        MockLibPointSaleConnectorPlatform();
    LibPointSaleConnectorPlatform.instance = fakePlatform;

    expect(
      await libPointSaleConnector.finishTransaction(
        listener: MockCliSiTefListener(),
        confirm: 1,
      ),
      0,
    );
  });

  test('getQttPendingTransactions', () async {
    LibPointSaleConnector libPointSaleConnector = LibPointSaleConnector();
    MockLibPointSaleConnectorPlatform fakePlatform =
        MockLibPointSaleConnectorPlatform();
    LibPointSaleConnectorPlatform.instance = fakePlatform;

    expect(
      await libPointSaleConnector.getQttPendingTransactions(
        taxInvoiceDate: '2024-05-16',
        taxInvoiceNumber: '123456',
      ),
      0,
    );
  });

  test('submitPendingMessages', () async {
    LibPointSaleConnector libPointSaleConnector = LibPointSaleConnector();
    MockLibPointSaleConnectorPlatform fakePlatform =
        MockLibPointSaleConnectorPlatform();
    LibPointSaleConnectorPlatform.instance = fakePlatform;

    expect(
      await libPointSaleConnector.submitPendingMessages(),
      0,
    );
  });

  test('isPinpadPresent', () async {
    LibPointSaleConnector libPointSaleConnector = LibPointSaleConnector();
    MockLibPointSaleConnectorPlatform fakePlatform =
        MockLibPointSaleConnectorPlatform();
    LibPointSaleConnectorPlatform.instance = fakePlatform;

    expect(
      await libPointSaleConnector.isPinpadPresent(),
      true,
    );
  });

  test('readYesNo', () async {
    LibPointSaleConnector libPointSaleConnector = LibPointSaleConnector();
    MockLibPointSaleConnectorPlatform fakePlatform =
        MockLibPointSaleConnectorPlatform();
    LibPointSaleConnectorPlatform.instance = fakePlatform;

    expect(
      await libPointSaleConnector.readYesNo('Do you want to continue?'),
      0,
    );
  });

  test('setPinpadMessage', () async {
    LibPointSaleConnector libPointSaleConnector = LibPointSaleConnector();
    MockLibPointSaleConnectorPlatform fakePlatform =
        MockLibPointSaleConnectorPlatform();
    LibPointSaleConnectorPlatform.instance = fakePlatform;

    expect(
      await libPointSaleConnector.setPinpadMessage(
        message: 'Welcome!',
        persistent: false,
      ),
      0,
    );
  });
}
