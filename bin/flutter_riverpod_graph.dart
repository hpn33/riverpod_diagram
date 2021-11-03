import 'dart:io';

import 'src/analyze.dart';
import 'src/directory.dart';

const landLearnPath = "C:\\ws\\flutter\\landlearn\\lib";

void main() {
  final filesPath = getFiles(landLearnPath);

  final vars = analyze(filesPath);

  for (var element in vars) {
    print(element.name);
  }
}

List<String> getFiles(String path) {
  return allDirContents(Directory(path))
      .where((e) => e.path.endsWith('.dart'))
      .map((e) => e.path)
      .toList();
}
