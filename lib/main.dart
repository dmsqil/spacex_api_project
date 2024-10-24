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
              return snapshot.data!.renderDetails();
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
