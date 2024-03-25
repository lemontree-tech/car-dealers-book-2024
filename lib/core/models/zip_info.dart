class ZipInfo {
  final int filesPerZip = 25;
  int maxLevel;
  Map<int, ZipLevelInfo> zipLevelInfos = {};

  ZipInfo.fromApiJson(Map<String, dynamic> json) : maxLevel = json['max_related_level'] as int {
    for (var i = 1; i <= maxLevel; i++) {
      final levelInfo = json[i.toString()];
      if (levelInfo is List<dynamic> && levelInfo.length >= 3) {
        zipLevelInfos[i] = ZipLevelInfo(
          level: i,
          currentOffset: levelInfo[0] as int,
          currentMaxOffset: levelInfo[1] as int,
          lastLevelNumberOfFiles: levelInfo[2] as int,
        );
      }
    }
  }

  int get totalNumberOfFiles => zipLevelInfos[1]?.lastLevelNumberOfFiles ?? 0;
}

class ZipLevelInfo {
  final int level;
  final int currentOffset;
  final int currentMaxOffset;
  final int lastLevelNumberOfFiles;

  ZipLevelInfo({
    required this.level,
    required this.currentOffset,
    required this.currentMaxOffset,
    required this.lastLevelNumberOfFiles,
  });
}
