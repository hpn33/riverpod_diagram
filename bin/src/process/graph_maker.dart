import '../model/collec_data.dart';
import '../model/graph_node.dart';

List<GraphNode> makeGraph(CollecData collecData) {
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
