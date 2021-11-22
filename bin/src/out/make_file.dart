import 'dart:io';

import '../model/graph_node.dart';

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
