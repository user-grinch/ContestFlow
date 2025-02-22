enum ContestPhase {
  before,
  running,
  finished,
  unknown,
}

enum ContestProvider {
  cc,
  cf,
  lc,
  unknown,
}

class ContestData {
  final String id;
  final String name;
  final ContestProvider provider;
  final ContestPhase phase;
  final int durationSeconds;
  final int startTimeSeconds;

  ContestData(
    this.id,
    this.name,
    this.provider,
    this.phase,
    this.startTimeSeconds,
    this.durationSeconds,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'provider': provider.toString().split('.').last,
      'phase': phase.toString().split('.').last,
      'startTimeSeconds': startTimeSeconds,
      'durationSeconds': durationSeconds,
    };
  }

  factory ContestData.fromJson(Map<String, dynamic> json) {
    return ContestData(
      json['id'],
      json['name'],
      _getProviderFromString(json['provider']),
      _getPhaseFromString(json['phase']),
      json['startTimeSeconds'],
      json['durationSeconds'],
    );
  }

  factory ContestData.fromCodechefFMT(Map<String, dynamic> json,
      {bool isFuture = false}) {
    return ContestData(
      json['contest_code'].toString(),
      json['contest_name'],
      ContestProvider.cc,
      isFuture ? ContestPhase.before : ContestPhase.running,
      DateTime.parse(json['contest_start_date_iso']).millisecondsSinceEpoch ~/
          1000,
      int.parse(json['contest_duration']) * 60,
    );
  }

  factory ContestData.fromCodeforcesFMT(Map<String, dynamic> json) {
    return ContestData(
      json['id'].toString(),
      json['name']
          .toString()
          .replaceAll('Codeforces', '')
          .replaceAll('codeforces', ''),
      ContestProvider.cf,
      _getPhaseFromString(json['phase']),
      json['startTimeSeconds'],
      json['durationSeconds'],
    );
  }

  factory ContestData.fromLeetcodeFMT(Map<String, dynamic> json) {
    return ContestData(
      json['title'].toString().toLowerCase().replaceAll(' ', '-'),
      json['title'],
      ContestProvider.lc,
      ContestPhase.before,
      json['startTime'],
      json['duration'],
    );
  }

  static ContestProvider _getProviderFromString(String provider) {
    switch (provider.toLowerCase()) {
      case 'cc':
        return ContestProvider.cc;
      case 'cf':
        return ContestProvider.cf;
      case 'lc':
        return ContestProvider.lc;
      default:
        return ContestProvider.unknown;
    }
  }

  static ContestPhase _getPhaseFromString(String phase) {
    switch (phase.toUpperCase()) {
      case 'BEFORE':
        return ContestPhase.before;
      case 'CODING':
        return ContestPhase.running;
      case 'FINISHED':
        return ContestPhase.finished;
      default:
        return ContestPhase.unknown;
    }
  }
}
