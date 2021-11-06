import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart';

import 'src/analyze.dart';
import 'src/directory.dart';
import 'src/parse.dart';

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

  // final vars =
  analyze(filesPath);

  final graph = makeGraph();

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

List<GraphNode> makeGraph() {
  /// make class type
  final clas = collecData.classList;
  final listTemp = <GraphNode>[];
  var index = 0;

  for (final i in List.generate(clas.length, (index) => index)) {
    index++;
    final cls = clas[i];

    listTemp.add(GraphNode(index, classDeclaration: cls));
  }

  /// make var type
  final vars = collecData.varList;

  for (final i in List.generate(vars.length, (index) => index)) {
    index++;
    final v = vars[i];

    listTemp.add(GraphNode(index, variable: v));
  }

  for (var element in listTemp) {
    element.makeEdges(listTemp);
  }

  return listTemp;
}

class GraphNode {
  final int id;
  final VariableDeclaration? variable;
  final ClassDeclaration? classDeclaration;
  // final String type;

  String get name => variable != null
      ? variable!.name.toString()
      : classDeclaration!.name.toString();

  final List<GraphNode> usedNode = [];

  GraphNode(this.id, {this.variable, this.classDeclaration});

  void makeEdges(List<GraphNode> nodes) {
    final body = (variable != null ? variable!.initializer : classDeclaration)
        .toString();

    for (final node in nodes) {
      if (node.variable == null) {
        // if is was class
        continue;
      }

      if (body.contains(node.name.toString())) {
        usedNode.add(node);
      }
    }
  }

  String label() {
    String title = '';

    if (variable != null) {
      final init = variable!.initializer.toString();

      if (init.contains(RegExp(r'(Stream|Future)Provider(\.|<|\(\()'))) {
        title = '>$name]';
      } else if (init.contains(
          RegExp(r'(State|StateNotifier|ChangeNotifier)Provider(\.|<|\(\()'))) {
        title = '[[$name]]';
      } else {
        title = '($name)';
      }
    } else if (classDeclaration != null) {
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
