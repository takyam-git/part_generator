library test.part_generator.part_of_files;

import "dart:io";
import "package:unittest/unittest.dart";
import "package:part_generator/part_generator.dart";

void main() {
  group("part_of_files", () {
    test("relative", () {
      PartOfFiles files = new PartOfFiles("example", "./example");
      List<String> parts = [];
      files.forEach((FileSystemEntity file) => parts.add(file.path));
      expect(
          parts,
          unorderedEquals(
              ["./example/fuga.dart", "./example/hoge/hoge.dart", "./example/something/bar.dart", "./example/something/foo.dart",]));
    });

    test("absolute", () {
      String base = "${Directory.current.path}/example";
      PartOfFiles files = new PartOfFiles("example", base);
      List<String> parts = [];
      files.forEach((FileSystemEntity file) => parts.add(file.path));
      expect(
          parts,
          unorderedEquals(
              ["${base}/fuga.dart", "${base}/hoge/hoge.dart", "${base}/something/bar.dart", "${base}/something/foo.dart",]));
    });

    test("zero depth", () {
      PartOfFiles files = new PartOfFiles("example", "example", glob: "*.dart");
      List<String> parts = [];
      files.forEach((FileSystemEntity file) => parts.add(file.path));
      expect(parts, unorderedEquals(["example/fuga.dart",]));
    });
  });
}
