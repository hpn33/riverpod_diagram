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

void makeMermaidFile(String path, List<GraphNode> nodes) {
  // access to file
  final file = File(path + '\\riverpod_diagram.md');
  // create
  if (!file.existsSync()) {
    file.createSync();
  }

  // make mermaid

  final sBuilder = StringBuffer();

  for (final node in nodes) {
    for (final usedNode in node.usedNode) {
      sBuilder.writeln('${usedNode.label()} --> ${node.label()} ;');
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

List<GraphNode> makeGraph(List<VariableDeclaration> vars) {
  final listTemp = <GraphNode>[];

  for (final i in List.generate(vars.length, (index) => index)) {
    final v = vars[i];

    listTemp.add(GraphNode(i, v));
  }

  for (var element in listTemp) {
    element.makeEdges(listTemp);
  }

  return listTemp;
}

class GraphNode {
  final int id;
  final VariableDeclaration variable;
  final String type;

  String get name => variable.name.toString();

  final List<GraphNode> usedNode = [];

  GraphNode(this.id, this.variable, {this.type = 'var'});

  void makeEdges(List<GraphNode> nodes) {
    final initializer = variable.initializer;

    for (final node in nodes) {
      if (initializer.toString().contains(node.name.toString())) {
        usedNode.add(node);
      }
    }
  }

  String label() {
    String title = '';

    if (type == 'var') {
      title = '($name)';
    } else if (type == 'class') {
      title = '(($name))';
    }

    return '$id$title';
  }
}

class GraphEdge {
  final int from;
  final int to;

  GraphEdge(this.from, this.to);
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
