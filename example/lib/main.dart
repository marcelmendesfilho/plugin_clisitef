import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lib_point_sale_connector/lib_point_sale_connector.dart';
import 'package:lib_point_sale_connector/models/clisitef_listener.model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final clisitef = CliSiTef();
  String textToShow = '';

  @override
  void initState() {
    super.initState();
    clisitef.configure(
      storeCode: '00000000',
      sitefAddress: '192.168.0.91:4096',
      terminalNumber: 'MP000000',
      additionalParams: '[TipoPinPad=ANDROID_BT;PinPad.MAC=C8:36:A3:0B:C9:34;ParmsClient=1=00000000000000;]',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Exemplo de pagamento presencial - CLISITEF',
            style: TextStyle(fontSize: 14),
          ),
        ),
        body: Column(
          children: [
            const Text('PinPad MAC: C8:36:A3:0B:C9:34;'),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 90,
                  child: Center(
                    child: TextButton(
                      onPressed: () => clisitef.startTransaction(
                        paymentMethod: PaymentMethod.debit.value,
                        value: '50,00',
                        couponNbr: '1',
                        operatorId: '1',
                        restrictions: Restrictions.debit.value,
                        numParcelas: '1',
                      ),
                      child: const Text('Débito à vista', maxLines: 2,),
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Center(
                    child: TextButton(
                      onPressed: () => clisitef.startTransaction(
                        paymentMethod: PaymentMethod.credit.value,
                        value: '50,00',
                        couponNbr: '1',
                        operatorId: '1',
                        restrictions: Restrictions.credit.value,
                        numParcelas: '1',
                      ),
                      child: const Text('Crédito à vista', maxLines: 2,),
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Center(
                    child: TextButton(
                      onPressed: () => clisitef.startTransaction(
                        paymentMethod: PaymentMethod.credit.value,
                        value: '50,00',
                        couponNbr: '1',
                        operatorId: '1',
                        restrictions: Restrictions.creditWithInstallments.value,
                        numParcelas: '2',
                      ),
                      child: const Text('Crédito parcelado', maxLines: 2,),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 200),
            // Center(
            //   child: TextButton(
            //     onPressed: () => clisitef.startTransaction(
            //       paymentMethod: '0',
            //       value: '50,00',
            //       couponNbr: '1',
            //       operatorId: '1',
            //       restrictions: '',
            //       numParcelas: '1',
            //     ),
            //     child: const Text('Pix'),
            //   ),
            // ),
            StreamBuilder<String>(
              stream: clisitef.cashierMsg,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return Text(snapshot.data!);
                }
                return const Text('');
              }
            ),
          ],
        ),
      ),
    );
  }
}

class CliSiTef extends CliSiTefListener {
  final _libPointSaleConnectorPlugin = LibPointSaleConnector();
  String _numParcelas = '';
  final StreamController<String> _inputStreamController = StreamController<String>.broadcast();

  Stream<String> get cashierMsg => _inputStreamController.stream;


  Future<int> configure({
    required String storeCode,
    required String sitefAddress,
    required String terminalNumber,
    String additionalParams = '',
  }) async {
    return _libPointSaleConnectorPlugin.init(
      storeCode: storeCode,
      sitefAddress: sitefAddress,
      terminalNumber: terminalNumber,
      additionalParams: additionalParams,
    );
  }

  Future<int> startTransaction({
    required String paymentMethod,
    required String value,
    required String couponNbr,
    required String operatorId,
    required String restrictions,
    String numParcelas = '1',
  }) async {
    _numParcelas = numParcelas;
    return _libPointSaleConnectorPlugin.startTransaction(
      listener: this,
      paymentMethod: paymentMethod,
      value: value,
      couponNbr: couponNbr,
      operatorId: operatorId,
      restrictions: restrictions,
    );
  }

  @override
  void onData(
    int currentStage,
    int command,
    int fieldId,
    int minLength,
    int maxLength,
    String input,
  ) {
    if([1,3,11,13].contains(command)){
      _inputStreamController.add(input);
    }
    if (command == 30 && fieldId == 505) {
      _libPointSaleConnectorPlugin.continueTransaction(
        listener: this,
        input: _numParcelas,
      );
    } else {
      _libPointSaleConnectorPlugin.continueTransaction(
        listener: this,
        input: '',
      );
    }
  }

  @override
  void onTransactionResult(int currentStage, int resultCode) {
    if (currentStage == 1 && resultCode == 0) {
      _libPointSaleConnectorPlugin.finishTransaction(
        listener: this,
        confirm: 1,
      );
    } else {
      if (resultCode == 0) {
        _inputStreamController.add('Transação finalizada!!');
      } else {
        // print('Ocorreu um erro');
      }
    }
  }
}

enum PaymentMethod {
  debit(value: '2'),
  credit(value: '3');

  const PaymentMethod({required this.value});

  final String value;

  static PaymentMethod fromString(String value) {
    switch (value) {
      case '3':
        return credit;
      case '2':
      default:
        return debit;
    }
  }
}

enum Restrictions {
  debit(
      value: 'TransacoesHabilitadas=16;[10;17;18;19;26;27;28;34;35;36;3031];'),
  credit(
      value: 'TransacoesHabilitadas=26;[10;16;17;18;19;27;28;34;35;36;3031];'),
  creditWithInstallments(
      value: 'TransacoesHabilitadas=27;[10;16;17;18;19;26;28;34;35;36;3031];');

  const Restrictions({required this.value});

  final String value;
}
