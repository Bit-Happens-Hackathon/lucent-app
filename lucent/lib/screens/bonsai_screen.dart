import 'package:flutter/material.dart';
import 'package:lucent/themes.dart';
import '../widgets/bonzai.dart';
import 'dart:convert';  

// Helper: build weeks of DayData from list of timestamps
List<WeekData> generateWeekData(List<DateTime> visits, {required int year, required int month}) {
  final daysInMonth = DateTime(year, month + 1, 0).day;
  final visitedSet = visits
      .where((dt) => dt.year == year && dt.month == month)
      .map((dt) => dt.day)
      .toSet();
  // First 28 days broken into 4 equal chunks of 7; any extra days (29th+) go to branches 1–N
  const int branches = 4;
  const int basePerBranch = 7;
  final extraDays = daysInMonth - basePerBranch * branches;
  List<WeekData> result = [];
  int cursor = 1;
  for (int i = 0; i < branches; i++) {
    // branch 0 always has basePerBranch days; branches 1.. get an extra day if extraDays >= index
    final additional = (i > 0 && (i <= extraDays)) ? 1 : 0;
    final count = basePerBranch + additional;
    List<DayData> days = [];
    for (int j = 0; j < count; j++) {
      days.add(DayData(visited: visitedSet.contains(cursor)));
      cursor++;
    }
    result.add(WeekData(days: days));
  }
  return result;
}

class BonsaiScreen extends StatelessWidget {
  const BonsaiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock JSON from Supabase with visit timestamps
    // const mockJson = '{"visits": ['
    //     '"2025-04-01T10:00:00Z",'
    //     '"2025-04-02T12:00:00Z",'
    //     '"2025-04-05T09:00:00Z",'
    //     '"2025-04-10T14:00:00Z",'
    //     '"2025-04-18T16:00:00Z",'
    //     '"2025-04-22T08:00:00Z",'
    //     '"2025-04-25T20:00:00Z"'
    //   ']}';

    const mockJson = '{"visits": ['
    '"2025-05-01T10:00:00Z",'
    '"2025-05-02T12:00:00Z",'
    '"2025-05-03T12:00:00Z",'
    '"2025-05-04T12:00:00Z",'
    '"2025-05-05T09:00:00Z",'
    '"2025-05-06T09:00:00Z",'
    '"2025-05-07T09:00:00Z",'
    '"2025-05-08T09:00:00Z",'
    '"2025-05-09T09:00:00Z",'
    '"2025-05-10T14:00:00Z",'
    '"2025-05-11T14:00:00Z",'
    '"2025-05-12T14:00:00Z",'
    '"2025-05-13T14:00:00Z",'
    '"2025-05-14T14:00:00Z",'
    '"2025-05-15T14:00:00Z",'
    '"2025-05-16T14:00:00Z",'
    '"2025-05-17T14:00:00Z",'
    '"2025-05-18T14:00:00Z",'
    '"2025-05-19T14:00:00Z",'
    '"2025-05-20T14:00:00Z",'
    '"2025-05-21T16:00:00Z",'
    '"2025-05-22T08:00:00Z",'
    '"2025-05-23T08:00:00Z",'
    '"2025-05-24T08:00:00Z",'
    '"2025-05-25T08:00:00Z",'
    '"2025-05-26T08:00:00Z",'
    '"2025-05-27T20:00:00Z",'
    '"2025-05-28T20:00:00Z",'
    '"2025-05-29T20:00:00Z",'
    '"2025-05-30T20:00:00Z",'
    '"2025-05-31T20:00:00Z"'
  ']}';

    final visitsList = json.decode(mockJson)['visits'] as List<dynamic>;
    final visits = visitsList.map((e) => DateTime.parse(e as String)).toList();
    // build weeks based on April 2025
    final sampleWeeks = generateWeekData(visits, year: 2025, month: 5);

    return Scaffold(
      appBar: AppBar(title: const Text('Bonsai Calendar')),
      body: Center(
        child: Container(
          width: 400,
          height: 400,
          color: AppColors.background,
          child: BonsaiTree(
            weeks: sampleWeeks,
            branchLengthFactor: 0.2, // controls main branch length relative to container width
            leafBranchLengthFactor: 0.50, // controls leaf puff radius relative to container width
            leafStemLengthFactor: 0.32,  // shorter stems
            leafSizeFactor: 0.05,       // leaf circle radius relative to width
          ),
        ),
      ),
    );
  }
}