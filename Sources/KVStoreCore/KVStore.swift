//
//  KVStore.swift
//  KVStore
//
//  Created by Nicholas Sakaimbo on 5/12/17.
//
//

import Foundation

public final class KVStore {
  
  public typealias StoreType = [String:String]
  
  lazy var consoleIO: IOProviding = ConsoleIO()
  
  var store: StoreType = [:]
  var _storeEditingStack = Stack<StoreType>()
  
  public init(_ input: StoreType = StoreType()) {
    self.store = input
  }
 
  public func run() {
    
    consoleIO.write("Hello. Welcome to KVStore. Usage:")
    consoleIO.write("SET <key> <value> to store the value for key")
    consoleIO.write("GET <key> to return the current value for key")
    consoleIO.write("DELETE <key> to remove the entry for key")
    consoleIO.write("COUNT <value> to return the number of keys that have the given value")
    consoleIO.write("BEGIN to start a new transaction")
    consoleIO.write("COMMIT <key> to complete the current transaction")
    consoleIO.write("ROLLBACK to revert to state prior to BEGIN call")
    
    while true {
      
      guard let command = consoleIO.getCommand(consoleIO.getInput()) else {
        return
      }
      
      _transaction(command)
    }
  }
  
  /// Batch operation which allows the user to commit or roll back their changes to the key-value store. This includes the ability to nest transactions and roll back and commit within nested transactions.
  ///
  /// To facilitate change tracking, this method calls itself recursively when the `BEGIN` command is entered.
  func _transaction(_ command: Command) {
    
    switch command {
      
    case .set(let key, let value):
      store[key] = value
      
    case .get(let key):
      
      let message:String = store[key] ?? "key not set"
      consoleIO.write(message)
      
    case .delete(let key):
      
      store[key] = nil
      
    case .count(let value):
      
      let count: Int = store.filter{$0.value == value}.count
      consoleIO.write("\(count)")
      
    case.begin:
      
      // Nested transaction starts out as a copy of the current transaction
      let newTransaction = store
      
      // Preserve current transaction in history
      _storeEditingStack.push(store)
      
      // Update current transaction
      store = newTransaction
      
    case .commit:
      
      if _storeEditingStack.isEmpty {
        consoleIO.write("no transaction")
      }
      else {
        
        _ = _storeEditingStack.pop()
        
        if !_storeEditingStack.isEmpty {
          _storeEditingStack.push(store)
        }
      }
      
    case .rollback:
      
      if _storeEditingStack.isEmpty {
        consoleIO.write("no transaction")
      }
      else if let first = _storeEditingStack.pop() {
        store = first
      }
    }
  }
}
