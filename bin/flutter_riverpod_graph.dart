import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';

import 'src/analyze.dart';
import 'src/directory.dart';

const landLearnPath = "C:\\ws\\flutter\\landlearn\\lib";

void main() {
  final filesPath = getFiles(landLearnPath);

  final vars = analyze(filesPath);

  final graph = makeGraph(vars);

  makeMermaidFile(landLearnPath, graph);
}

void makeMermaidFile(String path, Map<String, List<String>> graph) {
  // access to file
  final file = File(path + '\\riverpod_diagram.md');
  // create
  if (!file.existsSync()) {
    file.createSync();
  }

  // make mermaid

  final sBuilder = StringBuffer();

  for (final i in graph.entries) {
    for (final usedVariable in i.value) {
      sBuilder.writeln('$usedVariable --> ${i.key} ;');
    }

    sBuilder.writeln();
  }

  final output = """
  
```mermaid
graph TD;

$sBuilder
```

  """;

  file.writeAsStringSync(output);
}

List<String> getFiles(String path) {
  return allDirContents(Directory(path))
      .where((e) => e.path.endsWith('.dart'))
      .map((e) => e.path)
      .toList();
}

Map<String, List<String>> makeGraph(List<VariableDeclaration> vars) {
  final listTemp = <String, List<String>>{};

  for (final v in vars) {
    listTemp[v.name.toString()] = findUsedProviders(v, vars);
  }

  return listTemp;
}

List<String> findUsedProviders(
  VariableDeclaration variable,
  List<VariableDeclaration> vars,
) {
  final initializer = variable.initializer;

  final tempList = <String>[];

  for (final v in vars) {
    if (initializer.toString().contains(v.name.toString())) {
      tempList.add(v.name.toString());
    }
  }

  return tempList;
}
