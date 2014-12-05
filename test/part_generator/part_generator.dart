library test.part_generator.part_generator;

import "package:unittest/unittest.dart";
import "package:part_generator/part_generator.dart";

void main() {
  group("part_generator", () {
    test("PartGenerator", () {
      var generator = new PartGenerator("example", "./example");
      expect(generator.generate().toString(), equalsIgnoringWhitespace('''
      part "fuga.dart";
      part "hoge/hoge.dart";
      part "something/bar.dart";
      part "something/foo.dart";
    '''));
    });
  });
}