import 'package:test/test.dart';
import 'package:awareframework_rotation/awareframework_rotation.dart';

void main(){
  test("test sensor config", (){
    var config = RotationSensorConfig();
    expect(config.debug, false);
  });

}
