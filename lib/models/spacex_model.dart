import 'package:flutter/material.dart';

class LaunchData {
  final String name;
  final bool success;
  final String details;
  final String dateUtc;
  final List<String> crew;
  final Links links;

  LaunchData({
    required this.name,
    required this.success,
    required this.details,
    required this.dateUtc,
    required this.crew,
    required this.links,
  });

  factory LaunchData.fromJson(Map<String, dynamic> json) {
    return LaunchData(
      name: json['name'],
      success: json['success'],
      details: json['details'],
      dateUtc: json['date_utc'],
      crew: List<String>.from(json['crew'].map((crewId) => crewId.toString())),
      links: Links.fromJson(json['links']),
    );
  }

  Widget renderDetails() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    links.patch.large,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 16.0),
                Center(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Launch Success: ${success ? 'Yes' : 'No'}',
                  style: TextStyle(
                    fontSize: 18,
                    color: success ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Details:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  details,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Launch Date (UTC): $dateUtc',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.0),
                crew.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Crew:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            crew.join(', '),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'No Crew Members.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Links {
  final Patch patch;

  Links({
    required this.patch,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      patch: Patch.fromJson(json['patch']),
    );
  }
}

class Patch {
  final String small;
  final String large;

  Patch({
    required this.small,
    required this.large,
  });

  factory Patch.fromJson(Map<String, dynamic> json) {
    return Patch(
      small: json['small'],
      large: json['large'],
    );
  }
}
