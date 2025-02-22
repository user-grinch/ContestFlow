import 'dart:convert';

import 'package:contest_flow/constants/pref.dart';
import 'package:contest_flow/modal/contestdata.dart';
import 'package:contest_flow/services/prefservice.dart';
import 'package:contest_flow/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const codechefUrl =
    'https://www.codechef.com/api/list/contests/all?sort_by=START&sorting_order=asc&offset=0&mode=all';
const codeforcesUrl = 'https://codeforces.com/api/contest.list?gym=false';
const leetcodeUrl = 'https://leetcode.com/graphql';

// Don't know who knows this, better not use it
const commonUrl = 'https://competeapi.vercel.app/contests/upcoming';

class DataService extends Cubit<List<ContestData>> {
  DataService() : super([]) {
    _initialize();
  }

  Future<void> _initialize() async {
    refresh();
  }

  Future<Map<String, dynamic>?> _fetchCodeforces() async {
    final dio = Dio();
    try {
      final response = await dio.get(
        codeforcesUrl,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        Util.showToast("Codeforces data fetch error");
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  List<ContestData> _parseCodeforces(
    Map<String, dynamic>? data,
    List<ContestData> contests,
  ) {
    final int oneWeekInSeconds = 7 * 24 * 60 * 60;
    final int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    if (data != null) {
      for (var contest in data['result']) {
        if ((contest['phase'] == "BEFORE" || contest['phase'] == "CODING") &&
            contest['startTimeSeconds'] <= currentTime + oneWeekInSeconds) {
          contests.add(ContestData.fromCodeforcesFMT(contest));
        }
      }
      contests.sort((a, b) => a.startTimeSeconds.compareTo(b.startTimeSeconds));
    }
    return contests;
  }

  Future<Map<String, dynamic>?> _fetchLeetcode() async {
    Dio dio = Dio();

    try {
      Response response = await dio.post(
        leetcodeUrl,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          'query': '''
          {
            topTwoContests {
              title
              startTime
              duration
            }
          }
        '''
        },
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        Util.showToast("LeetCode data fetch error");
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  List<ContestData> _parseLeetcode(
    Map<String, dynamic>? data,
    List<ContestData> contests,
  ) {
    if (data != null) {
      for (var contest in data["data"]["topTwoContests"]) {
        contests.add(ContestData.fromLeetcodeFMT(contest));
      }
      contests.sort((a, b) => a.startTimeSeconds.compareTo(b.startTimeSeconds));
    }
    return contests;
  }

  Future<Map<String, dynamic>?> _fetchCodechef() async {
    Dio dio = Dio();

    try {
      Response response = await dio.post(
        codechefUrl,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        Util.showToast("CodeChef data fetch error");
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  List<ContestData> _parseCodechef(
    Map<String, dynamic>? data,
    List<ContestData> contests,
  ) {
    if (data != null) {
      for (var contest in data["future_contests"]) {
        contests.add(ContestData.fromCodechefFMT(contest, isFuture: true));
      }
      for (var contest in data["present_contests"]) {
        contests.add(ContestData.fromCodechefFMT(contest, isFuture: false));
      }
      contests.sort((a, b) => a.startTimeSeconds.compareTo(b.startTimeSeconds));
    }
    return contests;
  }

  Future<void> refresh() async {
    List<ContestData> contests = [];
    bool dbOp = false;
    if (SharedPrefService().getBool(PREF_PROVIDER_CODEFORCES, def: true)) {
      Map<String, dynamic>? data = await _fetchCodeforces();
      _parseCodeforces(data, contests);
      dbOp = true;
    }

    if (SharedPrefService().getBool(PREF_PROVIDER_LEETCODE, def: true)) {
      Map<String, dynamic>? data = await _fetchLeetcode();
      _parseLeetcode(data, contests);
      dbOp = true;
    }
    if (SharedPrefService().getBool(PREF_PROVIDER_CODECHEF, def: true)) {
      Map<String, dynamic>? data = await _fetchCodechef();
      _parseCodechef(data, contests);
      dbOp = true;
    }

    if (dbOp) {
      if (contests.isNotEmpty) {
        List<Map<String, dynamic>> data =
            contests.map((e) => e.toJson()).toList();
        SharedPrefService().saveString(PREF_STORE_CONTEST, jsonEncode(data));
      } else {
        String? contestsJson =
            SharedPrefService().getString(PREF_STORE_CONTEST);

        if (contestsJson != null) {
          List<dynamic> jsonData = jsonDecode(contestsJson);
          List<ContestData> data =
              jsonData.map((e) => ContestData.fromJson(e)).toList();
          contests = data;
        }
      }
    }

    emit(contests);
  }
}
