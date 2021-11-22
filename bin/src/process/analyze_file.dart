import 'dart:async';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/session.dart';

import '../in/directory.dart';
import '../model/collec_data.dart';
import 'parse.dart';

const landLearnPath = "C:\\ws\\flutter\\landlearn\\lib";

Future<void> main() async {
  // final vars =
  analyze(getFiles(landLearnPath), CollecData());

  // for (var element in vars) {
  //   print(element.name);
  // }
}

void analyze(List<String> filesPath, CollecData collecData) {
// final path = Directory.current.path + '\\bin\\';
  // final paths = await dirContents(Directory(landLearnPath));

  final collection = AnalysisContextCollection(includedPaths: filesPath);

  // analyzeSomeFiles(collection, includedPaths);

  // print('----');

  analyzeAllFiles(collection, collecData);
}

// void analyzeSomeFiles(
//   AnalysisContextCollection collection,
//   List<String> includedPaths,
//   CollecData collecData,
// ) {
//   for (String path in includedPaths) {
//     AnalysisContext context = collection.contextFor(path);
//     analyzeSingleFile(context, path, collecData);
//   }
// }

void analyzeAllFiles(
    AnalysisContextCollection collection, CollecData collecData) {
  for (AnalysisContext context in collection.contexts) {
    for (String path in context.contextRoot.analyzedFiles()) {
      analyzeSingleFile(context, path, collecData);
    }
  }
}

void analyzeSingleFile(
  AnalysisContext context,
  String path,
  CollecData collecData,
) {
  AnalysisSession session = context.currentSession;
  // ...

  processFile(session, path, collecData);
}
