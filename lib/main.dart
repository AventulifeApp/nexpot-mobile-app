import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings =
      const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'nexpot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'nexpot'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: [
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
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
        ),
        TextButton(
          onPressed: () async {
            try {
              const flavor = String.fromEnvironment('FLAVOR');
              await FirebaseFirestore.instance
                  .collection('test2')
                  .add({'name': flavor});
            } catch (e) {
              // ignore: avoid_print
              print(e);
            }
          },
          child: const Text('click here'),
        ),
        FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection('test').get(),
          builder: (context, snapshot) {
            if ((snapshot.data?.size ?? 0) > 0) {
              return Text(
                  "firebase Data: ${snapshot.data?.docs[0].data()["env"]} id: ${snapshot.data?.docs[0].id}");
            }
            return const Text("not found");
          },
        ),
      ]),
    );
  }
}
