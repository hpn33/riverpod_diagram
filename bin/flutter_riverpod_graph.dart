import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart';

import 'src/analyze.dart';
import 'src/directory.dart';

// const landLearnPath = "C:\\ws\\flutter\\landlearn\\lib";

const pathArg = 'path';

void main(List<String> arguments) {
  ///
  // final parser = ArgParser()..addOption(pathArg, abbr: 'p', defaultsTo: '.');
  // ArgResults argResults = parser.parse(arguments);

  // print(path.current);
  // print(argResults[pathArg]);
  // print(argResults.options);
  // print(paths);

  // final path = getPath(argResults[pathArg]);
  final path = current;

  final filesPath = getFiles(path);

  final vars = analyze(filesPath);

  final graph = makeGraph(vars);

  makeMermaidFile(path, graph);
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
