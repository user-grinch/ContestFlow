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
    final response = await dio.get(contestUrl);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      Util.showToast("Failed to fetch data");
      return null;
    }
  }

  Future<void> refresh() async {
    Map<String, dynamic>? data = await _getContestData();
    if (data != null) {
      List<ContestData> contests = [];
      for (var contest in data['result']) {
        if (contest['phase'] == "BEFORE" || contest['phase'] == "CODING") {
          contests.add(ContestData.fromJson(contest));
        }
      }
      contests.sort((a, b) => a.startTimeSeconds.compareTo(b.startTimeSeconds));
      SharedPrefService().saveString(
          'contests', jsonEncode(contests.map((e) => e.json).toList()));

      emit(contests);
    }
  }
}
