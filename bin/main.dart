import 'dart:io';
import 'package:args/args.dart';
import 'package:lang_to_docx/convert_docx.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption("lang", abbr: "l", help: "Programming language supported in Markdown.")
    ..addOption("output", abbr: "o", help: "Points to the generated docx file.")
    ..addFlag("help", abbr: "h");

  ArgResults argResults = parser.parse(arguments);

  if (argResults["help"]) {
    print(parser.usage);
    return;
  }

  final paths = argResults.rest;

  exitCode = await convertToDocx(
    markdownLanguage: argResults["lang"] as String,
    files: paths.map((path) => File(path)).toList(),
    outputFile: File(argResults["output"] as String),
  );
} 
