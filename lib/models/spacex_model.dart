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
