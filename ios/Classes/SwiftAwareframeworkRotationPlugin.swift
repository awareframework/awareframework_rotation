import Flutter
import UIKit
import SwiftyJSON
import com_awareframework_ios_sensor_rotation
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkRotationPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, RotationObserver{

    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                let json = JSON.init(config)
                self.rotationSensor = RotationSensor.init(RotationSensor.Config(json))
            }else{
                self.rotationSensor = RotationSensor.init(RotationSensor.Config())
            }
            self.rotationSensor?.CONFIG.sensorObserver = self
            return self.rotationSensor
        }else{
            return nil
        }
    }

    var rotationSensor:RotationSensor?

    public override init() {
        super.init()
        super.initializationCallEventHandler = self
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        // add own channel
        super.setChannels(with: registrar,
                          instance: SwiftAwareframeworkRotationPlugin(),
                          methodChannelName: "awareframework_rotation/method",
                          eventChannelName: "awareframework_rotation/event")

    }


    public func onDataChanged(data: RotationData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_data_changed" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
}
