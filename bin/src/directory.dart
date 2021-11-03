import 'dart:io';

// Future<List<FileSystemEntity>> dirContents(Directory dir) {
//   var files = <FileSystemEntity>[];
//   var completer = Completer<List<FileSystemEntity>>();

//   var lister = dir.list(recursive: false);
//   lister.listen(
//     (file) => files.add(file),
//     // should also register onError
//     onDone: () => completer.complete(files),
//   );

//   return completer.future;
// }

List<FileSystemEntity> allDirContents(Directory dir) => dir
    .listSync(recursive: false)
    .map((e) {
      if (e.statSync().type == FileSystemEntityType.directory) {
        return allDirContents(Directory(e.path));
      }

      return [e];
    })
    .expand((element) => element)
    .toList();
