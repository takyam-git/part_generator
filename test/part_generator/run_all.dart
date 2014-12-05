library test.part_generator;

import "package:unittest/unittest.dart";
import "part_generator.dart" as part_generator;
import "part_of_files.dart" as part_of_files;

void main() {
  group("part_generator", () {
    part_generator.main();
    part_of_files.main();
  });
}