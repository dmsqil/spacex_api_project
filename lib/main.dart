import 'package:flutter/material.dart';
import 'models/spacex_model.dart';
import 'services/spacex_api_service.dart'; // Importing the API service

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
                    data.links.patch.large,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 16.0),
                Center(
                  child: Text(
                    data.name,
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
                  'Launch Success: ${data.success ? 'Yes' : 'No'}',
                  style: TextStyle(
                    fontSize: 18,
                    color: data.success ? Colors.green : Colors.red,
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
                  data.details,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Launch Date (UTC): ${data.dateUtc}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.0),
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
