import 'dart:io';
import 'package:path/path.dart';

Future<int> convertToDocx({
  required String markdownLanguage,
  required List<File> files,
  required File outputFile,
}) async {
  String content = (await Future.wait(files.map((file) async {
    final String content = await file.readAsString();
    return "### ${basename(file.path)}\n```$markdownLanguage\n${content.trim()}\n```";
  })))
      .join("\n---\n\n");

  final dir = await Directory.systemTemp.createTemp();
  final temp = File("${dir.path}/temp");

  await temp.writeAsString(content);

  final output = await Process.run("pandoc", [
    temp.path,
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
