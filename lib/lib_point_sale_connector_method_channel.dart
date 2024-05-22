import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lib_point_sale_connector/models/clisitef_listener.model.dart';

import 'lib_point_sale_connector_platform_interface.dart';

/// An implementation of [LibPointSaleConnectorPlatform] that uses method channels.
class MethodChannelLibPointSaleConnector extends LibPointSaleConnectorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('lib_point_sale_connector');

  @override
  Future<int> init({
    required String storeCode,
    required String sitefAddress,
    required String terminalNumber,
    String additionalParams = '',
  }) async {
    try {
      final result = await methodChannel.invokeMethod<int>(
        'init',
        {
          'codigoLoja': storeCode,
          'enderecoSitef': sitefAddress,
          'numeroTerminal': terminalNumber,
          'parametrosAdicionais': additionalParams
        },
      );

      return result ?? -1;
    } on PlatformException {
      return -1;
    }
  }

  @override
  Future<int> startTransaction({
    required CliSiTefListener listener,
    required String paymentMethod,
    required String value,
    required String couponNbr,
    required String operatorId,
    required String restrictions,
  }) async {
    try {
      final currentDateTime = DateTime.now();

      final result = await methodChannel.invokeMethod(
        'startTransaction',
        {
          'modalidade': paymentMethod,
          'valor': value,
          'docFiscal': couponNbr,
          'dataFiscal': DateFormat('yyyyMMdd').format(currentDateTime),
          'horario': DateFormat('HHmmss').format(currentDateTime),
          'operador': operatorId,
          'restricoes': restrictions,
        },
      );
      if (result['command'] != '-1') {
        listener.onData(
          result['currentStage'],
          result['command'],
          result['fieldId'],
          result['minLength'],
          result['maxLength'],
          result['input'],
        );
      } else {
        listener.onTransactionResult(
            result['currentStage'], result['resultCode']);
      }
      return 0;
    } on PlatformException {
      return -1;
    }
  }

  @override
  Future<int> continueTransaction({
    required CliSiTefListener listener,
    required String input,
  }) async {
    try {
      final res =
          await methodChannel.invokeMethod('continueTransaction', input);
      
      if (res['command'] != '-1') {
        listener.onData(
          res['currentStage'],
          res['command'],
          res['fieldId'],
          res['minLength'],
          res['maxLength'],
          res['input'],
        );
      } else {
        listener.onTransactionResult(res['currentStage'], res['resultCode']);
      }

      return 0;
    } on PlatformException {
      return -1;
    }
  }

  @override
  Future<int> finishTransaction({
    required CliSiTefListener listener,
    required int confirm,
  }) async {
    try {
      final res =
          await methodChannel.invokeMethod('finishTransaction', confirm);

      if (res['command'] != '-1') {
        listener.onData(
          res['currentStage'],
          res['command'],
          res['fieldId'],
          res['minLength'],
          res['maxLength'],
          res['input'],
        );
      } else {
        listener.onTransactionResult(res['currentStage'], res['resultCode']);
      }

      return 0;
    } on PlatformException {
      return -1;
    }
  }

  @override
  Future<int> setPinpadMessage({
    required String message,
    required bool persistent,
  }) async {
    try {
      final result = await methodChannel.invokeMethod<int>('setPinpadMessage', {
        "message": message,
        "persistent": persistent.toString(),
      });
      return result ?? -1;
    } on PlatformException {
      return -1;
    }
  }

  @override
  Future<int> getQttPendingTransactions({
    required String taxInvoiceDate,
    required String taxInvoiceNumber,
  }) async {
    try {
      final result = await methodChannel.invokeMethod<int>(
          'getQttPendingTransactions', {
        'taxInvoiceDate': taxInvoiceDate,
        'taxInvoiceNumber': taxInvoiceNumber
      });
      return result ?? -1;
    } on PlatformException {
      return -1;
    }
  }

  @override
  Future<bool> isPinpadPresent() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('isPinpadPresent');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<int> readYesNo(String message) async {
    try {
      final result = await methodChannel.invokeMethod('readYesNo', message);
      return result ?? -1;
    } on PlatformException {
      return -1;
    }
  }

  @override
  Future<int> submitPendingMessages() async {
    try {
      final result =
          await methodChannel.invokeMethod<int>('submitPendingMessages');
      return result ?? -1;
    } on PlatformException {
      return -1;
    }
  }
}
