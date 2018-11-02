import Flutter
import UIKit
import Coucou

public class SwiftCoucouFlutterPlugin: NSObject, FlutterPlugin {
    private static let PLUGIN_PACKAGE = "com.github.mrmitew.coucou.flutter";
    
    private static let METHOD_CHANNEL = "\(PLUGIN_PACKAGE)/method_channel";
    private static let DISCOVERY_EVENT_CHANNEL = "\(PLUGIN_PACKAGE)/discovery_event_channel";
    
    private static let STOP_DISCOVERY = "stopDiscovery";
    private static let START_BROADCAST = "startBroadcast";
    private static let STOP_BROADCAST = "stopBroadcast";
    
    private static let GET_PLATFORM_VERSION = "getPlatformVersion";
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        do {
            let coucou = try Coucou.Builder()
                .driver(AppleBonjour())
                .logger(StandardLogger())
                .build()
            
            let discoveryStreamHandler = DiscoveryStreamHandler(with: coucou)
            let instance = SwiftCoucouFlutterPlugin(with: coucou, discoveryStreamHandler: discoveryStreamHandler)
            let methodChannel = FlutterMethodChannel(name: METHOD_CHANNEL, binaryMessenger: registrar.messenger())
            let discoveryEventChannel = FlutterEventChannel(name: DISCOVERY_EVENT_CHANNEL, binaryMessenger: registrar.messenger())
            
            discoveryEventChannel.setStreamHandler(discoveryStreamHandler)
            registrar.addMethodCallDelegate(instance, channel: methodChannel)
            
        } catch {
            // TODO(stefan): catch CoucouError.runtimeError(let errorMessage)
            print("The plugin could not be initialized.")
        } catch {
            print("The plugin could not be initialized. Unknown error.")
        }
    }
    
    private let coucou: Coucou
    private let discoveryStreamHandler: DiscoveryStreamHandler
    
    public init(with coucou: Coucou, discoveryStreamHandler: DiscoveryStreamHandler) {
        self.coucou = coucou
        self.discoveryStreamHandler = discoveryStreamHandler
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method) {
            case SwiftCoucouFlutterPlugin.GET_PLATFORM_VERSION:
                result("iOS " + UIDevice.current.systemVersion)
                break
            case SwiftCoucouFlutterPlugin.STOP_DISCOVERY:
                // TODO
                _ = discoveryStreamHandler.onCancel(withArguments: nil)
                break
            case SwiftCoucouFlutterPlugin.START_BROADCAST:
                result(FlutterError.init(code: "NOT_IMPLEMENTED", message: "Method \(call.method) is not implemented", details: nil))
                break
            case SwiftCoucouFlutterPlugin.STOP_BROADCAST:
                result(FlutterError.init(code: "NOT_IMPLEMENTED", message: "Method \(call.method) is not implemented", details: nil))
                break
            default:
                result(FlutterError.init(code: "NOT_IMPLEMENTED", message: "Method \(call.method) is not implemented", details: nil))
        }
    }
    
    // TODO: Call it on app destroy
    public func dispose() {
        // TODO
        discoveryStreamHandler.dispose()
    }
}

// TODO(stefan): Add one more layer to provide multiple network service discoveries to run in parallel
// and also to be canceled individually.

public class DiscoveryStreamHandler : NSObject, FlutterStreamHandler {
    private static let DEFAULT_DOMAIN = "local."
    private static let DEFAULT_SERVICE_TYPE = "_http._tcp."
    
    private let coucou: Coucou
    
    init(with coucou: Coucou) {
        self.coucou = coucou
    }
    
    private var disposable: Disposable?
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        // TODO: Parse the arguments. We need to be able to run multiple discovery requests
        // in parallel for different service types
        
        var type = DiscoveryStreamHandler.DEFAULT_SERVICE_TYPE
        var domain = DiscoveryStreamHandler.DEFAULT_DOMAIN
        
        if let args = arguments as? Dictionary<AnyHashable, Any> {
            type = args["type"] != nil ? args["type"] as! String : DiscoveryStreamHandler.DEFAULT_SERVICE_TYPE
            domain = args["domain"] != nil ? args["domain"] as! String : DiscoveryStreamHandler.DEFAULT_DOMAIN
        }
        
        // Start discovery
        disposable = coucou.startDiscovery(ofType: type, domain: domain) { (event) in
            // TODO something with the DiscoveryEvent
            
            if(event is ServiceResolved) {
                // TODO something with event.service
                print("Service resolved: \((event as! ServiceResolved).service.toDictionary())")
            } else if (event is ServiceLost) {
                // TODO something with event.service
                print("Service lost: \((event as! ServiceLost).service.toDictionary())")
            } else if (event is DiscoveryFinished) {
                // TODO
                print("Discovery finished")
            } else if (event is ResolvingFinished) {
                // TODO
                print("Resolving finished")
            } else if (event is DiscoveryFailure) {
                // TODO
                print("Discovery failure")
            }
            
            events(event.toDisctionary())
        }
    
        return nil
    }
    
    // TODO: Stop a concrete discovery request
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        disposable?.dispose()
        return nil
    }
    
    public func dispose() {
        disposable?.dispose()
    }
}
