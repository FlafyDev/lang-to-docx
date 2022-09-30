import 'dart:io';
import 'package:path/path.dart';

Future<int> convertToDocx({
  required String markdownLanguage,
  required List<File> files,
  required File outputFile,
  bool separateToPages = false,
}) async {
  List<String> contents = await Future.wait(files.map((file) async {
    final String content = await file.readAsString();
    return "### ${basename(file.path)}\n```$markdownLanguage\n${content.trim()}\n```";
  }));

  String content;
  if (separateToPages) {
      content = contents.join("\n\\newpage\n");
  } else {
      content = contents.join("\n---\n\n");
  }

  final dir = await Directory.systemTemp.createTemp();
  final tempInputFile = File("${dir.path}/tempInputFile");

  await tempInputFile.writeAsString(content);

  final output = await Process.run("pandoc", [
    tempInputFile.path,
    "--filter",
    "pandoc-docx-pagebreakpy",
    "-f",
    "markdown",
    "-t",
    "docx",
    "-o",
    outputFile.path,
  ], );

  print(output.stdout);
  print(output.stderr);

  await dir.delete(recursive: true);

  return output.exitCode;
}
