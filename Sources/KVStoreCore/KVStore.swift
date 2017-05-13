//
//  KVStore.swift
//  KVStore
//
//  Created by Nicholas Sakaimbo on 5/12/17.
//
//

import Foundation

public final class KVStore {
  
  typealias StoreType = [String:String]
  
  private let consoleIO = ConsoleIO()
 
  public init() {

  }
 
  public func run() {
    
    consoleIO.write("Hello. Welcome to KVStore. Usage:")
    print("SET <key> <value> to store the value for key")
    print("GET <key> to return the current value for key")
    print("DELETE <key> to remove the entry for key")
    print("COUNT <value> to return the number of keys that have the given value")
    print("BEGIN to start a new transaction")
    print("COMMIT <key> to complete the current transaction")
    print("ROLLBACK to revert to state prior to BEGIN call")
    
    _transaction()
  }
  
  /// Batch operation which allows the user to commit or roll back their changes to the key-value store. This includes the ability to nest transactions and roll back and commit within nested transactions.
  ///
  /// To facilitate change tracking, this method calls itself recursively when the `BEGIN` command is entered.
  /// - Parameters:
  ///   - input: A copy of the key-value store of the parent (if any). Empty by default.
  ///   - nested: A boolean flag indicating whether or not this is a recursive call. Set to `false` by default.
  /// - Returns: Key-value store that includes changes to the `input` parameter (if any).
  @discardableResult func _transaction(_ input: StoreType = [:], nested: Bool = false) -> StoreType {
    
    var copy = StoreType()
    
    copy.merge(with: input)
    
    transactionLoop: while true {
      
      guard let command = consoleIO.getCommand(consoleIO.getInput()) else {
        continue transactionLoop
      }
      
      switch command {
        
      case .set(let key, let value):
        copy[key] = value
        continue transactionLoop
        
      case .get(let key):
        let message:String = copy[key] ?? "key not set"
        consoleIO.write(message)
        
        continue transactionLoop
        
      case .delete(let key):
        
        copy[key] = nil
        continue transactionLoop
        
      case .count(let value):
        
        let count: Int = copy.filter{$0.value == value}.count
        consoleIO.write("\(count)")
        continue transactionLoop
        
      case.begin:
        
        copy.merge(with: _transaction(copy, nested: true))
        
        continue transactionLoop
        
      case .commit where !nested:
        consoleIO.write("no transaction")
        continue transactionLoop
        
      case .commit:
        return copy
        
      case .rollback where !nested:
        consoleIO.write("no transaction")
        continue transactionLoop
        
      case .rollback:
        
        copy = StoreType()
        return copy
      }
    }
  }
}

