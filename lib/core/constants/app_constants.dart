class AppConstants {
  static const String googleMapsApiKey =
      "AIzaSyBuK-19ZxMcqw56Lki80qUK3KYl3K9d2pg";
  static const List<String> categories = [
    "tourism",
    "food",
    "culture"
  ]; // ← este orden se mostrará
  static const Map<String, String> categoryIcons = {
    "tourism": "🏛️",
    "food": "🍽️",
    "culture": "🎭",
  };
  static const String prefSelectedCityId = "selected_city_id";
}
