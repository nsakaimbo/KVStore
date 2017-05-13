//
//  Command.swift
//  KVStore
//
//  Created by Nicholas Sakaimbo on 5/12/17.
//
//

import Foundation

/// Represents the universe of possible commands to the key-value store.
///
/// - set: Store value for key
/// - get: Return current value for key
/// - delete: Remove the entry for key
/// - count: Return the number of keys with the given value
/// - begin: Start a new transaction
/// - commit: Complete the current transaction
/// - rollback: Revert to state prior to BEGIN call
enum Command {
  
  case set(key: String, value: String)
  case get(key: String)
  case delete(key: String)
  case count(value: String)
  case begin
  case commit
  case rollback
  
  // Convenience initializer that parses a `String` input and returns an instance of `Command` with associated parameters (if any).
  init?(_ input: String) throws {
    
    let inputs = input.components(separatedBy: CharacterSet.whitespaces)
    
    let command = inputs[0]
    let arguments:[String] = inputs.count > 1 ? Array(inputs[1..<inputs.count]) : []
    
    switch command.lowercased() {
    case "set" where arguments.count != 2:
      throw Error.invalidArguments(reason: "SET: Invalid arguments.\nUsage: SET <key> <value>")
    case "set":
      self = Command.set(key: arguments[0], value: arguments[1])
    case "get" where arguments.count != 1:
      throw Error.invalidArguments(reason: "GET: Invalid arguments.\nUsage: GET <key>")
    case "get":
       self = Command.get(key: arguments[0])
    case "delete" where arguments.count != 1:
      throw Error.invalidArguments(reason: "DELETE: Invalid arguments.\nUsage: DELETE <key>")
    case "delete":
      self = Command.delete(key: arguments[0])
    case "count" where arguments.count != 1:
      throw Error.invalidArguments(reason: "COUNT: Invalid arguments.\nUsage: COUNT <value>")
    case "count":
      self = Command.count(value: arguments[0])
    case "begin":
      self = Command.begin
    case "commit":
      self = Command.commit
    case "rollback":
      self = Command.rollback
    default:
      throw Command.Error.invalidCommand(command: command)
    }
  }
}

extension Command {
  
  enum Error:Swift.Error {
    case invalidArguments(reason: String)
    case invalidCommand(command: String)
  }
}

extension Command.Error: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidArguments (let reason):
      return reason
      case .invalidCommand(let command):
        return "Command not found: \(command.uppercased())."
    }
  }
}

