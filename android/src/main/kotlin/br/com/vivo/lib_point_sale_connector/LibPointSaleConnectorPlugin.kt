package br.com.vivo.lib_point_sale_connector

import android.content.Context
import android.os.Handler
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.EventListener

import br.com.softwareexpress.sitef.android.CliSiTef
import br.com.softwareexpress.sitef.android.ICliSiTefListener

/** LibPointSaleConnectorPlugin */
class LibPointSaleConnectorPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var applicationContext: Context
  private lateinit var channel : MethodChannel
  private var clisitefListener: CliSiTefListener = CliSiTefListener()

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "lib_point_sale_connector")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when(call.method){
      "init" -> {
        var resp = clisitefListener.init(call.arguments as Map<String, String>, applicationContext)
        result.success(resp)
      }
      "startTransaction" -> {
        var resp = clisitefListener.startTransaction(call.arguments as Map<String, String>, result)
      }
      "setPinpadMessage" -> {
        var resp = clisitefListener.setPinpadMessage(call.arguments as Map<String, String>)
        result.success(resp)
      }
      "continueTransaction" -> {
        clisitefListener.pendingResult = result
        clisitefListener.continueTransaction(call.arguments as String)
      }
      "finishTransaction" -> {
        clisitefListener.pendingResult = result
        clisitefListener.finishTransaction(call.arguments as Int)
      }
      "submitPendingMessages" -> {
        result.success(clisitefListener.submitPendingMessages())
      }
      "getQttPendingTransactions" -> {
        val resp = clisitefListener.getQttPendingTransactions(call.arguments as Map<String, String>)
        result.success(resp)
      }
      "isPinpadPresent" -> {
        result.success(clisitefListener.isPinpadPresent())
      }
      "readYesNo" -> {
        val resp = clisitefListener.readYesNo(call.arguments as String)
        result.success(resp)
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

class CliSiTefListener : ICliSiTefListener {
  lateinit var pendingResult : Result
  private lateinit var operatorInput : String
  private lateinit var clisitef : CliSiTef
  private var handler: Handler = Handler()

  fun init(params: Map<String, String>, context: Context): Int {
    clisitef = CliSiTef(context)
    clisitef.setMessageHandler(handler)
    val enderecoSitef = params["enderecoSitef"]
    val codigoLoja = params["codigoLoja"]
    val numeroTerminal = params["numeroTerminal"]
    val parametrosAdicionais = params["parametrosAdicionais"]
    val resp = clisitef.configure(enderecoSitef, codigoLoja, numeroTerminal, parametrosAdicionais)
    return resp
  }

  fun startTransaction(params: Map<String, String>, result: Result): Int {
    val clisitef = CliSiTef.getInstance()
    pendingResult = result
    val modalidade = params["modalidade"]!!.toInt()
    val valor = params["valor"] 
    val docFiscal = params["docFiscal"] 
    val dataFiscal = params["dataFiscal"]
    val horaFiscal = params["horario"]
    val operador = params["operador"]
    val restricoes = params["restricoes"]
    val sts = clisitef.startTransaction(this, modalidade, valor, docFiscal, dataFiscal, horaFiscal, operador, restricoes)
    return sts
  }

  fun continueTransaction(input: String){
    val clisitef = CliSiTef.getInstance()
    clisitef.continueTransaction(input)
  }

  fun finishTransaction(confirm: Int){
    val clisitef = CliSiTef.getInstance()
    clisitef.finishTransaction(confirm)
  }

  fun isPinpadPresent(): Boolean {
    val clisitef = CliSiTef.getInstance()
    return clisitef.pinpad.isPresent()
  }

  fun readYesNo(message: String): Int {
    val clisitef = CliSiTef.getInstance()
    return clisitef.pinpad.readYesNo(message)
  }

  fun setPinpadMessage(params: Map<String, String>): Int {
    val clisitef = CliSiTef.getInstance()
    val message = params["message"]
    val persistent = params["persistent"]!!.toBoolean()
    return clisitef.pinpad.setDisplayMessage(message, persistent)
  }

  fun getQttPendingTransactions(params: Map<String, String>): Int {
    val clisitef = CliSiTef.getInstance()
    val taxInvoiceDate = params["taxInvoiceDate"]
    val taxInvoiceNumber = params["taxInvoiceNumber"]
    return clisitef.getQttPendingTransactions(taxInvoiceDate, taxInvoiceNumber)
  }

  fun submitPendingMessages(): Int {
    val clisitef = CliSiTef.getInstance()
    return clisitef.submitPendingMessages()
  }

  override fun onData(currentStage: Int, command: Int, fieldId: Int, minLength: Int, maxLength: Int, input: ByteArray){
    pendingResult.success(mapOf("currentStage" to currentStage, "command" to command, "fieldId" to fieldId, "minLength" to minLength, "maxLength" to maxLength, "input" to input.toString(Charsets.UTF_8)))
  }

  override fun onTransactionResult(currentStage: Int, resultCode: Int){
    pendingResult.success(mapOf("command" to "-1", "resultCode" to resultCode, "currentStage" to currentStage))
  }
}