import "package:unittest/unittest.dart";
import "part_generator/run_all.dart" as part_generator;

void main() {
  groupSep = " > ";
  part_generator.main();
}
