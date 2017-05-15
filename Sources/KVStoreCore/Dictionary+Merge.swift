//
//  Dictionary+Merge.swift
//  KVStore
//
//  Created by Nicholas Sakaimbo on 5/13/17.
//
//

import Foundation

extension Dictionary {
  
  /// Merges another dictionary in-place
  ///
  /// - Parameter dictionary: A dictionary with the same `Key` and `Value` types as the receiver.
  mutating func merge(with dictionary: Dictionary<Key,Value>) {
    
    for (key, value) in dictionary {
      self[key] = value
    }
  }
  
  /// Merges the contents of the receiver with another dictionary, returning a new dictionary of merged key-value pairs.
  ///
  /// - Parameter dictionary: A dictionary with the same `Key` and `Value` types as the receiver.
  /// - Returns: A dictionary with the merged key-value pairs
  func merged(with dictionary: Dictionary<Key,Value>) -> Dictionary<Key,Value> {
    
    var copy = self
    
    for (key, value) in dictionary {
      copy[key] = value
    }
    return copy
  }
  
}
