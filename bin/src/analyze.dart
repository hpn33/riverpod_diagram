import 'dart:async';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';

import '../flutter_riverpod_graph.dart';
import 'parse.dart';

Future<void> main() async {
  final vars = analyze(getFiles(landLearnPath));

  for (var element in vars) {
    print(element.name);
  }
}

List<VariableDeclaration> analyze(List<String> filesPath) {
// final path = Directory.current.path + '\\bin\\';
  // final paths = await dirContents(Directory(landLearnPath));

  final collection = AnalysisContextCollection(includedPaths: filesPath);

  // analyzeSomeFiles(collection, includedPaths);

  // print('----');

  return analyzeAllFiles(collection);
}

List<VariableDeclaration> analyzeSomeFiles(
    AnalysisContextCollection collection, List<String> includedPaths) {
  final l = <VariableDeclaration>[];

  for (String path in includedPaths) {
    AnalysisContext context = collection.contextFor(path);
    l.addAll(analyzeSingleFile(context, path));
  }

  return l;
}

List<VariableDeclaration> analyzeAllFiles(
    AnalysisContextCollection collection) {
  final l = <VariableDeclaration>[];

  for (AnalysisContext context in collection.contexts) {
    for (String path in context.contextRoot.analyzedFiles()) {
      l.addAll(analyzeSingleFile(context, path));
    }
  }

  return l.toList();
}

List<VariableDeclaration> analyzeSingleFile(
    AnalysisContext context, String path) {
  AnalysisSession session = context.currentSession;
  // ...

  return processFile(session, path);
}
