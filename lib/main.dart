import 'package:flutter/material.dart';
import 'dart:convert'; // Untuk menguraikan JSON
import 'package:http/http.dart' as http; // Untuk HTTP request

void main() {
  runApp(SpaceXApp());
}

class SpaceXApp extends StatelessWidget {
  const SpaceXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpaceX API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpaceXHomePage(),
    );
  }
}

class SpaceXHomePage extends StatefulWidget {
  const SpaceXHomePage({super.key});

  @override
  _SpaceXHomePageState createState() => _SpaceXHomePageState();
}

class _SpaceXHomePageState extends State<SpaceXHomePage> {
  late Future<LaunchData> futureLaunchData;

  @override
  void initState() {
    super.initState();
    futureLaunchData = fetchLaunchData();
  }

  Future<LaunchData> fetchLaunchData() async {
    final response = await http.get(Uri.parse(
        'https://api.spacexdata.com/v4/launches/5eb87d46ffd86e000604b388'));

    if (response.statusCode == 200) {
      return LaunchData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SpaceX Demo Mission 2'),
      ),
      body: Center(
        child: FutureBuilder<LaunchData>(
          future: futureLaunchData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return LaunchDetails(data: snapshot.data!);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class LaunchDetails extends StatelessWidget {
  final LaunchData data;

  const LaunchDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Membungkus seluruh tampilan dengan SingleChildScrollView
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4, // Memberikan shadow pada card
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12), // Membuat sudut card melengkung
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar misi
                Center(
                  child: Image.network(
                    data.links.patch.large,
                    height: 120, // Mengurangi tinggi gambar
                    fit: BoxFit
                        .contain, // Membuat gambar tetap dalam ukuran proporsional
                  ),
                ),
                SizedBox(height: 16.0), // Spasi antara gambar dan teks

                // Nama Misi
                Center(
                  child: Text(
                    data.name,
                    style: TextStyle(
                      fontSize:
                          22, // Mengurangi ukuran font untuk menyesuaikan layar
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent, // Warna teks biru
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8.0), // Spasi antara teks

                // Informasi Keberhasilan Peluncuran
                Text(
                  'Launch Success: ${data.success ? 'Yes' : 'No'}',
                  style: TextStyle(
                    fontSize: 18,
                    color: data.success
                        ? Colors.green
                        : Colors.red, // Warna teks sesuai hasil
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16.0),

                // Detail Misi
                Text(
                  'Details:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  data.details,
                  style: TextStyle(
                    fontSize: 14, // Mengurangi ukuran font detail
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16.0),

                // Tanggal Peluncuran
                Text(
                  'Launch Date (UTC): ${data.dateUtc}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.0),

                // Daftar Kru (jika ada)
                data.crew.isNotEmpty
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
                            data.crew.join(', '),
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
