import 'dart:convert';
import 'package:daily_task/Myjson.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../app/constans/app_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<Album> fetchData() async {
  String url = 'https://api.npoint.io/30df1b498ced4b9f8454';
  final http.Response response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    try {
      final dynamic data = jsonDecode(response.body);
      // Now you can access the values of the JSON object
      final album = Album.fromJson(data);
      return album;
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to decode data from the API');
    }
  } else {
    throw Exception('Failed to load data from the API');
  }
}

makePostRequest(String ip, String name) async {
  print("makePostRequest" + ip + name);
  final uri = Uri.parse('http://httpbin.org/post');
  final headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> body = {'id': 21, 'name': 'bob'};
  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    uri,
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

  int statusCode = response.statusCode;
  String responseBody = response.body;
}

class Album {
  final int numExecutors;
  // final boolean offline;
  final bool temporarilyOffline;

  const Album({
    required this.numExecutors,
    // required this.offline,
    required this.temporarilyOffline,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      numExecutors: json['numExecutors'],
      // offline: json['offline'],
      temporarilyOffline: json['temporarilyOffline'],
    );
  }
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<ResourceFinder> searchlist = [];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchlist = mylist;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      height: size.height,
      width: size.width,
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              prefixIcon: Icon(EvaIcons.search),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: .1),
              ),
              hintText: "search..",
            ),
            textInputAction: TextInputAction.search,
            onChanged: (value) {
              searchAppointments(value);
            },
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_, i) => SizedBox(height: 8),
              itemCount: searchlist.length,
              itemBuilder: (_, i) {
                return ListTile(
                    onTap: () {},
                    hoverColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                    ),
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 50,
                      height: 50,
                      child: searchlist[i].type == "Selenoid"
                          ? Icon(Icons.star, color: Colors.amber)
                          : searchlist[i].type == "GGR"
                              ? Icon(Icons.check, color: Colors.green)
                              : Icon(Icons.warning, color: Colors.red),
                    ),
                    title: Text(searchlist[i].name.toString()),
                    subtitle: Text(searchlist[i].ip.toString()),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == "0") {
                          print(printNameAndIP(i));
                        } else if (value == "1") {
                          makePostRequest("1.1.1.1", "xy");
                          printNameAndIP(i);
                        } else {
                          print("Nothing");
                          printNameAndIP(i);
                        }
                      },
                      itemBuilder: (BuildContext bc) {
                        if (searchlist[i].type == "Selenoid") {
                          return [
                            const PopupMenuItem(
                              child: Text("Selenoid Restart"),
                              value: '0',
                            ),
                            const PopupMenuItem(
                              child: Text("Selenoid Update"),
                              value: '1',
                            ),
                            const PopupMenuItem(
                              child: Text("Selenoid Space Check"),
                              value: '2',
                            ),
                          ];
                        } else if (searchlist[i].type == "GGR") {
                          return [
                            const PopupMenuItem(
                              child: Text("GGR Restart"),
                              value: '0',
                            ),
                            const PopupMenuItem(
                              child: Text("GGR Update"),
                              value: '1',
                            ),
                            const PopupMenuItem(
                              child: Text("GGR Space Check"),
                              value: '2',
                            ),
                          ];
                        } else {
                          return [
                            const PopupMenuItem(
                              child: Text("Jenkins Restart"),
                              value: '0',
                            ),
                            const PopupMenuItem(
                              child: Text("Jenkins Update"),
                              value: '1',
                            ),
                            const PopupMenuItem(
                              child: Text("Jenkins Space Check"),
                              value: '2',
                            ),
                          ];
                        }
                      },
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

  printNameAndIP(int index) {
    print("Name: ${searchlist[index].name}, IP: ${searchlist[index].ip}");
  }

  void searchAppointments(String query) {
    var mysuggestions = mylist.where((element) {
      final name = element.name.toString().toLowerCase();
      final ip = element.ip.toString();
      final input = query.toLowerCase();
      return name.contains(input) || ip.contains(input);
    }).toList();
    setState(() {
      searchlist = mysuggestions;
    });
  }
}
