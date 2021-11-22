import 'package:path/path.dart';

import 'src/process/analyze_file.dart';
import 'src/in/directory.dart';
import 'src/out/make_file.dart';
import 'src/model/collec_data.dart';
import 'src/process/graph_maker.dart';

void main(List<String> arguments) {
  /// in
  final path = current;
  final filesPath = getFiles(path);

  // process
  final collecData = CollecData();
  analyze(filesPath, collecData);

  final graph = makeGraph(collecData);

  // out
  makeMermaidFile(path, graph);
}
