import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterwallpaper/wallpaper_detail.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: MyAppPage(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
      ),
      title: 'Flutter Wallpaper',
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyAppPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppPage> {
  final String URL = "https://picsum.photos/v2/list";
  List data;
  bool submitting = false;

  @override
  void initState() {
    super.initState();
    this.getWallpaperJsonData();
  }

  Future<String> getWallpaperJsonData() async {
    submitting = true;
    var response = await http.get(
        // Encode the URL
        Uri.encodeFull(URL),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      submitting = false;
      setState(() {
        var convertDataToJSON = jsonDecode(response.body);
        data = convertDataToJSON;
      });
    } else {
      print("No Data found");
    }

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Wallpaper',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: TabBar(
              unselectedLabelColor: Colors.green,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.green),
              tabs: [
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.green, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("ALL"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.green, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("RECENT"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.green, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("TRENDING"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: !submitting
              ? new GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.height / 1200,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 16,
                  children: List.generate(
                    data.length,
                    (index) {
                      return Container(
                        color: Colors.white,
                        child: Card(
                          child: InkResponse(
                            child: Image.network(
                              data[index]['download_url'],
                              fit: BoxFit.cover,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WallpaperDetail(
                                    imageURL: data[index]['download_url'],
                                  ),
                                ),
                              );
                            },
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                        ),
                      );
                    },
                  ),
                  padding: EdgeInsets.only(left: 14, right: 14, top: 16, bottom: 10),
                )
              : const Center(child: const CircularProgressIndicator()),
        ),
      ),
    );
  }
}
