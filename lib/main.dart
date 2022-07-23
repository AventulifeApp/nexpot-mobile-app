import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    const flavor = String.fromEnvironment('FLAVOR');
    print(flavor);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder<PackageInfo>(
        builder: (context, snapshot) {
          String appName = snapshot.data?.appName ?? "";
          String packageName = snapshot.data?.packageName ?? "";
          String version = snapshot.data?.version ?? "";
          String buildNumber = snapshot.data?.buildNumber ?? "";

          return Column(children: [
            Text(appName),
            Text(packageName),
            Text(version),
            Text(buildNumber),
          ]);
        },
        future: PackageInfo.fromPlatform(),
      )),
    );
  }
}
