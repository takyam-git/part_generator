part of part_generator;

/**
 * A [PartGenerator] generate `part "path/to/part/of.dart";` text which in [_rootDirectoryPah] and part of [libraryName].
 *
 *  For example:
 *
 *      print(new ParTGenerator('library_name', '/path/to/lib').generate().toString());
 *      // part "something/bar.dart";
 *      // part "something/foo.dart";
 *
 * [generate] method returns [PartGeneratorResult]. Not String.
 */
class PartGenerator {
  String _rootDirectoryPath;
  PartOfFiles _files;

  PartGenerator(String libraryName, this._rootDirectoryPath) {
    this._files = new PartOfFiles(libraryName, this._rootDirectoryPath);
  }

  /**
   * This [generate] will collect dart files which has `part of`, and generate `part "path/to/part/of.dart"` text.
   * [generate] returns [PartGeneratorResult] instance.
   *
   * ForExample:
   *
   *      print(new ParTGenerator('library_name', '/path/to/lib').generate().toString());
   *      // part "something/bar.dart";
   *      // part "something/foo.dart";
   */
  PartGeneratorResult generate() {
    //result string container
    StringBuffer exportContent = new StringBuffer();

    //Get target dart files, and generate `part "relative/path/to/part_file.dart"` strings.
    this._files.forEach((File partFile) {
      exportContent.write('part "${path.relative(partFile.path, from: this._rootDirectoryPath)}";\n');
    });

    //Get result
    PartGeneratorResult result = new PartGeneratorResult(exportContent.toString());

    //Cleanup
    exportContent.clear();

    return result;
  }
}

/**
 * PartGeneratorResult.generate() will returns this instance.
 * There is [toString] method only.
 */
class PartGeneratorResult {
  String _result;

  PartGeneratorResult(this._result);

  @override
  String toString() {
    return _result;
  }
}
