import Flutter
import UIKit
import com_awareframework_ios_sensor_rotation
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkRotationPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, RotationObserver{

    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                self.rotationSensor = RotationSensor.init(RotationSensor.Config(config))
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
        let instance = SwiftAwareframeworkRotationPlugin()
        // add own channel
        
        super.setMethodChannel(with: registrar, instance: instance, channelName: "awareframework_rotation/method")
        super.setEventChannels(with: registrar, instance: instance, channelNames: ["awareframework_rotation/event","awareframework_rotation/event_on_data_changed"])
    }


    public func onDataChanged(data: RotationData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_data_changed" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
}
