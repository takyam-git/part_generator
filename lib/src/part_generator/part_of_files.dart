part of part_generator;

/**
 * [PartOfFiles] class is List of `part of` Dart files.
 *
 * You can use something like List object.
 *
 * For example:
 *
 *      PartOfFiles files = new PartOfFiles("my_library", "./lib");
 *
 *      //print all `part of` dart files path.
 *      files.forEach((File partOfFile) => print(partOfFile.path));
 *
 * So you can use map(), forEach(), where() and more iterator methods.
 */
class PartOfFiles extends Object with IterableMixin<FileSystemEntity> {
  final String _libraryName;
  final String _rootDirectoryPath;
  final String _globPath;
  List<FileSystemEntity> _partOfFiles;
  bool _isFetched = false;

  /**
   * Collect dart files in [root] that has 'part of [libraryName]' declaration.
   * A [libraryName] is target library's name.
   *
   * And Optional Parameter [glob] is pattern for glob.
   * default value is '**.dart'.
   * This means collect all dart files under the [root] directory and it's subdirectories.
   * For example:
   *
   *      //Common usage
   *      PartOfFiles files = new PartOfFiles("library_name", "/path/to/lib");
   *      //Collect files only under the root with no depth
   *      PartOfFiles files = new PartOfFiles("library_name", "/path/to/lib", glob: "*.dart");
   *
   */
  PartOfFiles(String libraryName, String root, {String glob: '**.dart'})
      : this._init(libraryName, root, glob);

  /**
   * Private constructor for initialize.
   */
  PartOfFiles._init(this._libraryName, this._rootDirectoryPath, this._globPath) {
    this._partOfFiles = new List<FileSystemEntity>();
  }

  /**
   * Get iterator
   */
  Iterator<FileSystemEntity> get iterator {
    if (!this._isFetched) {
      this._fetch();
      this._isFetched = true;
    }
    return this._partOfFiles.iterator;
  }

  /**
   * Get and set dependency dart files to this.
   */
  void _fetch() {
    this._getDependencyFiles().forEach((FileSystemEntity dartFile) {
      bool isPartOfTargetLibraryDartFile = analyzer.parseDartFile(dartFile.path) // Dart file convert to AST
      .directives // Get AST directives
      .any((analyzer.Directive directive) => this._isTargetLibraryPartOfDirective(directive)); // Check has `part of`

      // Add to list when [dartFile] is part of target library
      if (isPartOfTargetLibraryDartFile) {
        this._partOfFiles.add(dartFile);
      }
    });
  }

  /**
   * Get dart files in root directory and sub directories.
   */
  List<FileSystemEntity> _getDependencyFiles() {
    final Glob dartFiles = new Glob(this._globPath);
    return dartFiles.listSync(root: this._rootDirectoryPath);
  }

  /**
   * Check a passed [directive] is `part of` directive of target library.
   */
  bool _isTargetLibraryPartOfDirective(analyzer.Directive directive) {
    if (!(directive is analyzer.PartOfDirective)) {
      return false;
    }
    if ((directive as analyzer.PartOfDirective).libraryName.name != this._libraryName) {
      return false;
    }
    return true;
  }
}
