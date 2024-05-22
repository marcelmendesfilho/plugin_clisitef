import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_point_sale_connector/lib_point_sale_connector_method_channel.dart';
import 'package:lib_point_sale_connector/models/clisitef_listener.model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelLibPointSaleConnector platform =
      MethodChannelLibPointSaleConnector();
  const MethodChannel channel = MethodChannel('lib_point_sale_connector');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'init':
            return 0;
          case 'startTransaction':
            return {
              'command': 0,
              'currentStage': 0,
              'fieldId' : 0,
              'minLength': 0,
              'maxLength': 0,
              'input': '',
              'resultCode': 0,
            };
          case 'continueTransaction':
            return {
              'command': 0,
              'currentStage': 0,
              'fieldId' : 0,
              'minLength': 0,
              'maxLength': 0,
              'input': '',
              'resultCode': 0,
            };
          case 'finishTransaction':
            return {
              'command': -1,
              'currentStage': 0,
              'fieldId' : 0,
              'minLength': 0,
              'maxLength': 0,
              'input': '',
              'resultCode': 0,
            };
          case 'setPinpadMessage':
            return 0;
          case 'getQttPendingTransactions':
            return 0;
          case 'isPinpadPresent':
            return true;
          case 'readYesNo':
            return 0;
          case 'submitPendingMessages':
            return 0;
          default:
            throw PlatformException(
              code: 'UNIMPLEMENTED',
              message: 'Method not implemented on mock',
            );
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('init', () async {
    final result = await platform.init(
      storeCode: '00000000',
      sitefAddress: '192.168.0.91:4096',
      terminalNumber: 'MP000000',
      additionalParams:
          '[TipoPinPad=ANDROID_BT;PinPad.MAC=C8:36:A3:0B:C9:34;ParmsClient=1=00000000000000;]',
    );
    expect(result, 0);
  });

  test('startTransaction', () async {
    final result = await platform.startTransaction(
      listener: MockCliSiTefListener(),
      paymentMethod: '2',
      value: '50,00',
      couponNbr: '1',
      operatorId: '1',
      restrictions:
          'TransacoesHabilitadas=16;[10;17;18;19;26;27;28;34;35;36;3031];',
    );
    expect(result, 0);
  });

  test('continueTransaction', () async {
    final result = await platform.continueTransaction(
      listener: MockCliSiTefListener(),
      input: '',
    );
    expect(result, 0);
  });

  test('finishTransaction', () async {
    final result = await platform.finishTransaction(
      listener: MockCliSiTefListener(),
      confirm: 1,
    );
    expect(result, 0);
  });

  test('setPinpadMessage', () async {
    final result = await platform.setPinpadMessage(
      message: 'Test message',
      persistent: false,
    );
    expect(result, 0);
  });

  test('getQttPendingTransactions', () async {
    final result = await platform.getQttPendingTransactions(
      taxInvoiceDate: '',
      taxInvoiceNumber: '',
    );
    expect(result, 0);
  });

  test('isPinpadPresent', () async {
    final result = await platform.isPinpadPresent();
    expect(result, true);
  });

  test('readYesNo', () async {
    final result = await platform.readYesNo('Selecione uma opção');
    expect(result, 0);
  });

  test('submitPendingMessages', () async {
    final result = await platform.submitPendingMessages();
    expect(result, 0);
  });
}

class MockCliSiTefListener extends CliSiTefListener {
  MethodChannelLibPointSaleConnector platform =
      MethodChannelLibPointSaleConnector();
  @override
  void onData(
    int currentStage,
    int command,
    int fieldId,
    int minLength,
    int maxLength,
    String input,
  ) {
    platform.continueTransaction(
      listener: this,
      input: '',
    );
  }

  @override
  void onTransactionResult(int currentStage, int resultCode) {
    if (currentStage == 1 && resultCode == 0) {
      platform.finishTransaction(
        listener: this,
        confirm: 1,
      );
    }
  }
}
