import 'package:analyzer/dart/ast/ast.dart';

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
