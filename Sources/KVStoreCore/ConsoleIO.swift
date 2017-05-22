//
//  ConsoleIO.swift
//  KVStore
//
//  Created by Nicholas Sakaimbo on 5/12/17.
//
//

import Foundation

/// Represents the choice of output stream
///
/// - error: Standard Error (stderr)
/// - standard: Standard Output (stdout)
enum OutputType {
  case error
  case standard
}

protocol IOProviding {
  func getInput() -> String
  func getCommand(_ input: String) -> Command?
  func write(_ message: String, to stream: OutputType)
}

extension IOProviding {
  
  func getInput() -> String {
    let keyboard = FileHandle.standardInput
    let inputData = keyboard.availableData
    let strData = String(data: inputData, encoding: String.Encoding.utf8)!
    return strData.trimmingCharacters(in: CharacterSet.newlines)
  }
  
  func getCommand(_ input: String) -> Command? {
    
    do {
      let command = try Command(input)
      return command
    }
    catch let error as Command.Error {
      write(error.localizedDescription, to: .error)
      return nil
    }
    catch {
      write("Undefined error occurred with input: \(input)", to: .error)
      return nil
    }
  }
  
  func write(_ message: String, to stream: OutputType = .standard) {
    switch stream {
    case .standard:
      print("\(message)")
    case .error:
      fputs("\(message)\n", stderr)
    }
  }
}

final class ConsoleIO: IOProviding { }
