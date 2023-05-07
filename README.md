![git-split-commit](/img/banner_1100x330.png)


A bash script that splits a git commit into multiple commits, one for each modified file.

**Check out my [blog](https://medium.com/@blipinsk) :shipit: or say *hi* on [Twitter](https://twitter.com/blipinsk).**

How does it work?
=================

![how_it_works](/img/how_it_works.png)

Installation
============

1. Clone the repo
2. (_optional_) Install git alias

```shell
./install-git-alias.sh
```

Although the second step is _optional_, it is strongly advised. You can use the script directly without installing the git alias, but git alias makes it much better.

Usage
=====

To split a Git commit, run the git alias for the script with the hash of the commit to split as the only argument:
```shell
Usage: git split-commit <commit_hash> [options]
Options:
  --version, -v     Prints the version of the script
  --help, -h        Prints this usage message
```

Example
=======
![example](/img/example.png)


Developed by
============
 * Bartek Lipinski

License
=======

Copyright 2023 Bartosz Lipiński

This script is licensed under the [Mozilla Public License 2.0](LICENSE).