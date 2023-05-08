import 'dart:convert';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:daily_task/app/utils/helpers/app_helpers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchData() async {
  String url = 'https://api.npoint.io/30df1b498ced4b9f8454';
  final http.Response response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final dynamic data = jsonDecode(response.body);
    // Now you can access the values of the JSON object
    final album = Album.fromJson(data);
    return album;
  } else {
    throw Exception('Failed to load data from the API');
  }
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

class GGRTaskData {
  final String label;
  final String jobDesk;
  final DateTime dueDate;

  const GGRTaskData({
    required this.label,
    required this.jobDesk,
    required this.dueDate,
  });
}

class GGRTask extends StatelessWidget {
  const GGRTask({
    required this.data,
    required this.primary,
    required this.onPrimary,
    Key? key,
  }) : super(key: key);

  final GGRTaskData data;
  final Color primary;
  final Color onPrimary;

  // get response async {
  //   String data = (await fetchJSONData()) as String;
  // }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        child: InkWell(
          onTap: () {},
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, primary.withOpacity(.7)],
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.bottomCenter,
              ),
            ),
            child: _BackgroundDecoration(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildLabel(),
                          const SizedBox(height: 20),
                          _buildJobdesk(),
                        ],
                      ),
                    ),
                    const Spacer(flex: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDate(),
                        SizedBox(
                          height: 20,
                          child: VerticalDivider(
                            thickness: 1,
                            color: onPrimary,
                          ),
                        ),
                        _buildHours(),
                      ],
                    ),
                    const Spacer(flex: 2),
                    _doneButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return Text(
      data.label,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: onPrimary,
        letterSpacing: 1,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildJobdesk() {
    return Container(
      decoration: BoxDecoration(
        color: onPrimary.withOpacity(.3),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        data.jobDesk,
        style: TextStyle(
          color: onPrimary,
          fontSize: 10,
          letterSpacing: 1,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDate() {
    return _IconLabel(
      color: onPrimary,
      iconData: EvaIcons.calendarOutline,
      label: DateFormat('d MMM').format(data.dueDate),
    );
  }

  Widget _buildHours() {
    return _IconLabel(
      color: onPrimary,
      iconData: EvaIcons.clockOutline,
      label: data.dueDate.dueDate(),
    );
  }

  Widget _doneButton() {
    return ElevatedButton.icon(
      onPressed: () {
        fetchData().then((album) {
          Fluttertoast.showToast(
            msg: 'Status: ${album.temporarilyOffline}',
            gravity: ToastGravity.BOTTOM,
          );
        });
      },
      style: ElevatedButton.styleFrom(
        primary: onPrimary,
        onPrimary: primary,
      ),
      icon: const Icon(EvaIcons.checkmarkCircle2Outline),
      label: const Text("Done"),
    );
  }
}

class _IconLabel extends StatelessWidget {
  const _IconLabel({
    required this.color,
    required this.iconData,
    required this.label,
    Key? key,
  }) : super(key: key);

  final Color color;
  final IconData iconData;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          color: color,
          size: 18,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(.8),
          ),
        )
      ],
    );
  }
}

class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration({required this.child, Key? key})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Transform.translate(
            offset: const Offset(25, -25),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(.1),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Transform.translate(
            offset: const Offset(-70, 70),
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white.withOpacity(.1),
            ),
          ),
        ),
        child,
      ],
    );
  }
}