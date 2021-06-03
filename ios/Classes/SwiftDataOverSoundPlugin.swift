import Flutter
import UIKit
import QuietModemKit

public class SwiftDataOverSoundPlugin: NSObject, FlutterPlugin,FlutterStreamHandler {
    
    
    final var TAG = "DataOverSoundPlugin"
    
    var rx: QMFrameReceiver?;
    var tx: QMFrameTransmitter = {
      let txConf: QMTransmitterConfig = QMTransmitterConfig(key: "ultrasonic-experimental");
      let tx: QMFrameTransmitter = QMFrameTransmitter(config:txConf);
      return tx;
    }()
    var mEvents:FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "data_over_sound", binaryMessenger: registrar.messenger())
        let instance = SwiftDataOverSoundPlugin()
        let scanChannel = FlutterEventChannel.init(name: "data_over_sound.scan",binaryMessenger: registrar.messenger());
        
        scanChannel.setStreamHandler(instance)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        DispatchQueue.main.async { [self] in
            switch call.method {
            
            case "init":
                initialize(call:call, result: result)
                
            case "scan":
                scan(call:call, result: result)
                
            case "send":
                send(call:call, result: result)

            case "stop":
                stop(result: result)
        
            default:
                result(FlutterMethodNotImplemented)
                return
            }
        }
    }

     private func initialize(call: FlutterMethodCall, result: @escaping FlutterResult){
        do {
            if let args = call.arguments as? Dictionary<String, Any>,
               let key = args["key"] as? String {
                tx = {
                    let txConf: QMTransmitterConfig = QMTransmitterConfig(key: key );
                    let tx: QMFrameTransmitter = QMFrameTransmitter(config:txConf);
                    return tx;
                }()
                print("Initialized with: \(key)")
                result(true)
            }
            else {
                result(FlutterError.init(code: TAG, message: nil, details: "init failed"))
            }
        }
        
    }
    
    public  func send(call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            
            if let args = call.arguments as? Dictionary<String, Any>,
               let msg = args["data"] as? String {
                let data = msg.data(using: .utf8);
                self.tx.send(data);
                print("sent \(msg)")
                result(true)
            }
            
        }
    }
    
    public func scan(call: FlutterMethodCall, result: @escaping FlutterResult){
        do {
            
            if let args = call.arguments as? Dictionary<String, Any>,
               let key = args["key"] as? String {
                AVAudioSession.sharedInstance().requestRecordPermission({ [self](granted: Bool)-> Void in
                    if granted {
                        if self.rx == nil {
                            let rxConf: QMReceiverConfig = QMReceiverConfig(key:key );
                            self.rx = QMFrameReceiver(config: rxConf);
                            self.rx?.setReceiveCallback(self.receiveCallback);
                        }
                    } else {
                        result(FlutterError.init(code: TAG, message: nil, details: "Permission to record not granted"))
                    }
                })
                result(true)
            }
            else {
                result(FlutterError.init(code: TAG, message: nil, details: "init failed"))
            }
        }
        
    }
    
    public func stop(result: @escaping FlutterResult){
        self.rx?.close();
        self.rx = nil
        result(true)
    }
    
    public func onListen(withArguments arguments: Any?,
                         eventSink: @escaping FlutterEventSink) -> FlutterError? {
        
        if arguments as? Int == 0 {
            mEvents = eventSink
        }
        
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.rx?.close();
        self.rx = nil
        return nil
    }
    
   
    
    func receiveCallback(frame: Data?) {
        let msg = String(data: frame ?? Data(), encoding: String.Encoding.utf8) ?? "data could not be decoded";
        print(msg)
        mEvents?(msg)
    }
    
}
