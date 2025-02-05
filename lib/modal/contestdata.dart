enum ContestPhase {
  before,
  coding,
  pendingSystemTest,
  systemTest,
  finished,
  unknown,
}

enum ContestType {
  cf,
  icpc,
  ioi,
  unknown,
}

class ContestData {
  final int id;
  final String name;
  final ContestType type;
  final ContestPhase phase;
  final bool frozen;
  final int durationSeconds;
  final int startTimeSeconds;
  final int relativeTimeSeconds;
  final Map<String, dynamic> json;

  ContestData(
    this.id,
    this.name,
    this.type,
    this.phase,
    this.frozen,
    this.durationSeconds,
    this.startTimeSeconds,
    this.relativeTimeSeconds,
    this.json,
  );

  factory ContestData.fromJson(Map<String, dynamic> json) {
    return ContestData(
      json['id'],
      json['name'],
      _getType(json['type']),
      _getPhase(json['phase']),
      json['frozen'],
      json['durationSeconds'],
      json['startTimeSeconds'],
      json['relativeTimeSeconds'],
      json = json,
    );
  }

  static ContestPhase _getPhase(String phase) {
    switch (phase) {
      case 'BEFORE':
        return ContestPhase.before;
      case 'CODING':
        return ContestPhase.coding;
      case 'PENDING_SYSTEM_TEST':
        return ContestPhase.pendingSystemTest;
      case 'SYSTEM_TEST':
        return ContestPhase.systemTest;
      case 'FINISHED':
        return ContestPhase.finished;
      default:
        return ContestPhase.unknown;
    }
  }

  static ContestType _getType(String type) {
    switch (type) {
      case 'CF':
        return ContestType.cf;
      case 'ICPC':
        return ContestType.icpc;
      case 'IOI':
        return ContestType.ioi;
      default:
        return ContestType.unknown;
    }
  }
}
