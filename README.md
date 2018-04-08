# 🍹 Icetea - Refreshment for Xcode users.

Icetea is a command line tool written in Swift which provides some useful interactions with Xcode.

## Features
- [X] Find and open Xcode files (workspace, project or playground).
- [X] Delete the derived data folder.
- [X] Create a playground.

## Installation

### [Mint](https://github.com/yonaskolb/mint)

```
$ mint install svenbacia/Icetea icetea
```

### Manual
1. Clone the project
2. Build the executable. `make build` helps you with that.
3. Copy the executable from the `.build` folder to your desired location. You can also run `make copy` which will copy the executable to `~/bin/icetea`.

You can combine step 2 and 3 by running `make install` directly.

## Usage

Icetea offers 3 main actions.

```
ddd                     🗑  Delete derived data.
open                    🚀  Find and open an Xcode workspace, project or playground.
playground              🛠  Create and open a new Xcode playground.
```

### Delete Derived Data (ddd)
`ddd` will delete your derived data folder. To terminate and open Xcode after derived data was deleted you can provide the `--close` and `--open` option.

```
--close, -c   💥  Xcode will be terminated before deleting the derived data folder.
--open, -o    🚀  Looks for a Xcode workspace, project or playground in the current folder and opens it after the derived data folder got deleted.
```

### Open
Open an Xcode project (workspace, project or playground).

```
--extension, -e   📦  Search for a specific Xcode file like workspace, project or playground
--list, -l        📖  List all Xcode project files from the current directory (including subdirectories).
--path, -p        📁  Search in a specific subdirectory for the Xcode file.
```

### Playground
Create a new playground which will be saved on your Desktop by default. The path can be changed with the `--path` option.

```
--path, -p     📁  Specify the path where the playground will be create. Default: ~/Desktop/
--target, -t   📱  Specify the playground platform target (ios, macos, tvos). Default: ios
```

## Tips
I have created an alias for the most common actions is use:

```
alias x='icetea open'
alias ddd='icetea ddd --close --open'
alias xp='icetea playground'
```

## Questions, feedback or suggestions?
I am [@svenbacia](https://twitter.com/svenbacia) on Twitter.

## Acknowledgement
Icetea uses [Xgen](https://github.com/johnsundell/xgen) by [@johnsundell](https://twitter.com/johnsundell).