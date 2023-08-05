import 'dart:convert';

typedef Json = Map<String, dynamic>;

extension StringToJson on String {
  Json toJson() => jsonDecode(this) as Json;

  List<Json> toJsonList() =>
      (jsonDecode(this) as List).whereType<Json>().toList();
}
