# KVStore

## Overview
Command line interface to a transactional key value store, allowing a user to `COMMIT` and `ROLLBACK` batches of nested transactions. For example:

```
> SET foo 123
> SET bar abc
> BEGIN
> SET foo 456
> GET foo
456
> SET bar def
> GET bar
def
> ROLLBACK
> GET foo
123
> GET bar
abc
> COMMIT
no transaction
```
## Installation
The utility can be run directly in the terminal or from Xcode.

### Run in Terminal
 1. Clone this repository
 2. In the terminal, `cd` to the root directory of the project and run the following commands:
 3. `$ swift build` to compile the executable
 4. `$ .build/debug/KVStore` to run the exectuable just created

### Run/View in Xcode
 1. Clone this repository
 2. In the terminal, `cd` to the root directory of the project and run the following commands:
 3. `$ swift package generate-xcodeproj` to generate the Xcode project file
 4. `open KVStore.xcodeproj` to view and build/run the file in Xcode

## Highlights
 * Uses a `Command` enum with associated values to structure commands and their corresponding arguments:
 ```
 enum Command {
  case set(key: String, value: String)
  case get(key: String)
  case delete(key: String)
  case count(value: String)
  case begin
  case commit
  case rollback
 }
 ```
 The `Command` initializer will `throw` and print to Standard Error when an invalid input is entered by the user.
 
 * Ability to track and discard changes is driven by the `_transaction(_:, nested:)` method in `KVOStore.swift`, which recursively calls itself when the `BEGIN` command is issued and conversely returns when `COMMIT` is entered by the user.
 
 ## Opportunities for Enhancement
Overall learned a lot doing this little project (never really used the Swift Package Manager or built a command line tool in Swift before) and I'm really happy with the overall solution. Although I attempted to expose key dependencies of the design, the recursive nature of the solution makes unit testing a little tricky (without having to pass launch arguments via scheme). I welcome any and all suggestions on how to add some tests! :)

## References
Some references I found helpful along the way:
 * [Command Line Programs on macOS Tutorial](https://www.raywenderlich.com/128039/command-line-programs-macos-tutorial)
 * [Building a command line tool using the Swift Package Manager](https://medium.com/@johnsundell/building-a-command-line-tool-using-the-swift-package-manager-3dd96ce360b1)
