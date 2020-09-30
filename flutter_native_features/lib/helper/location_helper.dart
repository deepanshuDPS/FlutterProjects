const API_KEY = "AIzaSyBqK2QCaun_YoEZ7NkQ8KF64HwlzzhWdFM";

class LocationHelper {
  static String getLocationImage({String latitude, String longitude}) {
    return "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=6&size=400x400&markers=color:blue%7Clabel:S%7C$latitude,$longitude&markers=size:tiny%7Ccolor:green&key=$API_KEY";
  }
}
