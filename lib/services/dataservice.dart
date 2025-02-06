import 'dart:convert';

import 'package:contest_flow/modal/contestdata.dart';
import 'package:contest_flow/services/prefservice.dart';
import 'package:contest_flow/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const contestUrl = 'https://codeforces.com/api/contest.list?gym=false';

class DataService extends Cubit<List<ContestData>> {
  DataService() : super([]) {
    _initialize();
  }

  Future<void> _initialize() async {
    refresh();
  }

  Future<Map<String, dynamic>?> _getContestData() async {
    final dio = Dio();
    try {
      final response = await dio.get(
        contestUrl,
        options: Options(
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        Util.showToast("Failed to fetch data");
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> refresh() async {
    List<ContestData> contests = [];
    Map<String, dynamic>? data = await _getContestData();
    if (data != null) {
      for (var contest in data['result']) {
        if (contest['phase'] == "BEFORE" || contest['phase'] == "CODING") {
          contests.add(ContestData.fromJson(contest));
        }
      }
      contests.sort((a, b) => a.startTimeSeconds.compareTo(b.startTimeSeconds));
      SharedPrefService().saveString(
          'contests', jsonEncode(contests.map((e) => e.json).toList()));
    } else {
      String? contestsJson = SharedPrefService().getString('contests');
      if (contestsJson != null) {
        List<dynamic> data = jsonDecode(contestsJson);
        contests = data.map((e) => ContestData.fromJson(e)).toList();
      }
    }
    emit(contests);
  }
}
