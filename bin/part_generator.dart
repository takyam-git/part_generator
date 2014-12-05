import "dart:io";
import "package:args/args.dart";
import "package:path/path.dart" as path;
import 'package:part_generator/part_generator.dart';

void main(List<String> arguments) {
  new Runner(arguments).run();
}

class Runner {
  List<String> _arguments;
  ArgParser _argParser;
  ArgResults _argResults;

  Runner(this._arguments) {
    this._argParser = new ArgParser();
  }

  /**
   * Runner's main process
   */
  void run() {
    //Check arguments that is help mode or invalid, then show help (and error messages)
    this._parseArguments();
    if (this._arguments.isEmpty || this._isHelpMode() || !this._validateArguments()) {
      this._showHelp();
      return;
    }

    //When has collect arguments, run main process
    this._showPartFiles(this._getOption('library-name'), this._getOption('root'));
  }

  /**
   * Main process.
   * Collect dart files and show `part "relative/path/to/part_file.dart"` strings.
   */
  void _showPartFiles(String libraryName, String rootDirectoryPath) {
    //convert path to full path.
    rootDirectoryPath = this._convertToFullPath(rootDirectoryPath);
    PartGenerator generator = new PartGenerator(libraryName, rootDirectoryPath);
    print(generator.generate().toString());
  }

  void _parseArguments() {
    this._argParser
      ..addOption('root', abbr: 'r', help: 'Set root directory path of target library.', valueHelp: '/path/to/library')
      ..addOption('library-name', abbr: 'l', help: 'Set target library name.', valueHelp: 'library_name')
      ..addFlag('help', abbr: 'h', help: 'This help.', negatable: false);
    this._argResults = this._argParser.parse(this._arguments);
  }

  bool _isHelpMode() {
    return this._hasOption('help') && this._getOption('help');
  }

  void _showHelp() {
    print('### part_generator - Usage ###');
    print(this._argParser.getUsage());
  }

  bool _validateArguments() {
    bool hasError = false;
    if (!this._hasOption('root') || this._getOption('root').isEmpty) {
      print('"--root" (or "-r") is required. Please set library root directory path.');
      hasError = true;
    }
    if (!this._hasOption('library-name') || this._getOption('library-name').isEmpty) {
      print('"--library-name" (or "-l") is required. Please set library name.');
      hasError = true;
    }
    return !hasError;
  }

  dynamic _getOption(String key) {
    if (this._hasOption(key)) {
      return this._argResults[key];
    }
    return null;
  }

  bool _hasOption(String key) {
    if (!(this._argResults is ArgResults)) {
      throw new NullThrownError();
    }
    return this._argResults.options.contains(key);
  }

  String _convertToFullPath(String directoryPath) {
    if (path.isRelative(directoryPath)) {
      directoryPath = path.normalize("${Directory.current.path}${path.separator}${directoryPath}");
    }
    return directoryPath;
  }
}