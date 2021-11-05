import 'dart:io';

import 'package:args/args.dart';

// const lineNumber = 'line-number';
const pathArg = 'path';

void main(List<String> arguments) {
  exitCode = 0; // presume success

  final parser = ArgParser()..addOption(pathArg, abbr: 'p', defaultsTo: '.');
  ArgResults argResults = parser.parse(arguments);
  // final paths = argResults.rest;

  // print(argResults.name);
  // print(argResults.command);
  // print(argResults.arguments);
  // print(argResults.rest);

  // print(path.current);
  print(argResults[pathArg]);
  print(argResults.options);
  // print(paths);

  // dcat(paths, showLineNumbers: argResults[path]);

  exit(0);
}

// Future<void> dcat(List<String> paths, {bool showLineNumbers = false}) async {
//   if (paths.isEmpty) {
//     // No files provided as arguments. Read from stdin and print each line.
//     await stdin.pipe(stdout);
//   } else {
//     for (final path in paths) {
//       var lineNumber = 1;
//       final lines = utf8.decoder
//           .bind(File(path).openRead())
//           .transform(const LineSplitter());
//       try {
//         await for (final line in lines) {
//           if (showLineNumbers) {
//             stdout.write('${lineNumber++} ');
//           }
//           stdout.writeln(line);
//         }
//       } catch (_) {
//         await _handleError(path);
//       }
//     }
//   }
// }

// Future<void> _handleError(String path) async {
//   if (await FileSystemEntity.isDirectory(path)) {
//     stderr.writeln('error: $path is a directory');
//   } else {
//     exitCode = 2;
//   }
// }
