import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For HTTP requests
import '../models/spacex_model.dart'; // Adjust the import path accordingly

Future<LaunchData> fetchLaunchData() async {
  final response = await http.get(Uri.parse(
      'https://api.spacexdata.com/v4/launches/5eb87d46ffd86e000604b388'));

  if (response.statusCode == 200) {
    return LaunchData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}
