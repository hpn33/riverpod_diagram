import 'dart:async';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';

import '../main.dart';
import 'parse.dart';

const landLearnPath = "C:\\ws\\flutter\\landlearn\\lib";

Future<void> main() async {
  // final vars =
  analyze(getFiles(landLearnPath));

  // for (var element in vars) {
  //   print(element.name);
  // }
}

void analyze(List<String> filesPath) {
// final path = Directory.current.path + '\\bin\\';
  // final paths = await dirContents(Directory(landLearnPath));

  final collection = AnalysisContextCollection(includedPaths: filesPath);

  // analyzeSomeFiles(collection, includedPaths);

  // print('----');

  analyzeAllFiles(collection);
}

void analyzeSomeFiles(
    AnalysisContextCollection collection, List<String> includedPaths) {
  for (String path in includedPaths) {
    AnalysisContext context = collection.contextFor(path);
    analyzeSingleFile(context, path);
  }
}

void analyzeAllFiles(AnalysisContextCollection collection) {
  for (AnalysisContext context in collection.contexts) {
    for (String path in context.contextRoot.analyzedFiles()) {
      analyzeSingleFile(context, path);
    }
  }
}

void analyzeSingleFile(AnalysisContext context, String path) {
  AnalysisSession session = context.currentSession;
  // ...

  processFile(session, path);
}
