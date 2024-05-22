import Flutter
import UIKit

public class LibPointSaleConnectorPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "lib_point_sale_connector", binaryMessenger: registrar.messenger())
    let instance = LibPointSaleConnectorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "init":
        let paramsMap:[String: String]
        if let params = call.arguments as? [String: String]
        {
            paramsMap = params
        }
        result(configure(params:paramsMap))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func configure(params: [String: String]) -> Int {
    var enderecoSitef = params["enderecoSitef"]
    var codigoLoja = params["codigoLoja"]
    var numeroTerminal = params["numeroTerminal"]
    var parametrosAdicionais = params["parametrosAdicionais"]
    return ConfiguraIntSiTefInterativo(enderecoSitef, codigoLoja, numeroTerminal, 0, parametrosAdicionais)
  }
}
