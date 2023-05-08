import 'package:flutter/material.dart';

import 'package:daily_task/app/constans/app_constants.dart';
import '../app/shared_components/card_task.dart';
import '../app/shared_components/ggr_task.dart';

final taskInProgress = [
  GGRTaskData(
    label: "Team Sanity",
    jobDesk: "CI CD",
    dueDate: DateTime.now().add(const Duration(minutes: 50)),
  ),
  GGRTaskData(
    label: "Team Sanity",
    jobDesk: "CI CD",
    dueDate: DateTime.now().add(const Duration(minutes: 50)),
  ),
  GGRTaskData(
    label: "Team Sanity",
    jobDesk: "CI CD",
    dueDate: DateTime.now().add(const Duration(minutes: 50)),
  ),
  GGRTaskData(
    label: "Regression",
    jobDesk: "PipeLine",
    dueDate: DateTime.now().add(const Duration(hours: 4)),
  ),
  GGRTaskData(
    label: "Fraud & Security",
    jobDesk: "BlackDuck",
    dueDate: DateTime.now().add(const Duration(days: 2)),
  ),
  GGRTaskData(
    label: "AIML",
    jobDesk: "AIML Team",
    dueDate: DateTime.now().add(const Duration(minutes: 50)),
  ),
];

class GGRScreen extends StatefulWidget {
  const GGRScreen({Key? key}) : super(key: key);

  @override
  _GGRScreenState createState() => _GGRScreenState();
}

class _GGRScreenState extends State<GGRScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(height: 50),
          Container(
            height: 250,
            width: size.width,
            child: _TaskInProgress(data: taskInProgress),
          ),
        ],
      ),
    );
  }
}

class _TaskInProgress extends StatelessWidget {
  const _TaskInProgress({
    required this.data,
    Key? key,
  }) : super(key: key);

  final List<GGRTaskData> data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadius * 2),
      child: SizedBox(
        height: 250,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: kSpacing / 2),
            child: GGRTask(
              data: data[index],
              primary: _getSequenceColor(index),
              onPrimary: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Color _getSequenceColor(int index) {
    int val = index % 4;
    if (val == 3) {
      return Colors.indigo;
    } else if (val == 2) {
      return Colors.grey;
    } else if (val == 1) {
      return Colors.redAccent;
    } else {
      return Colors.lightBlue;
    }
  }
}
