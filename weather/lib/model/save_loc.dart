import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
part 'save_loc.g.dart';

@HiveType(typeId: 1)
class SaveLoc extends HiveObject {
  @HiveField(1)
  double lat;
  @HiveField(2)
  double lon;
  SaveLoc(this.lat, this.lon);
}
