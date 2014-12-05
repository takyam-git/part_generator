# part_generator package

The Dart Language `part`/`part of` structure needs too many `part of` line on entry dart file.
But I don't want to write myself it.

So this package generate `part of 'path/to/part/of.dart'` lines automatically!

_But currently output to console only_

## Usage

```
[Show Help]
$ bin/part_generator -h
> ### part_generator - Usage ###
> -r, --root=</path/to/library>        Set root directory path of target library.
> -l, --library-name=<library_name>    Set target library name.
> -h, --help                           This help.

[library foo in lib/]
$ bin/part_generator -r ./lib -l foo
> part "foo/src/bar.dart";
> part "foo/src/something.dart";
```

and, copy and paste to your library entry file.