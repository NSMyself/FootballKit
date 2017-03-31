//
//  Queue.swift
//  FootballKit
//
//  Created by Matthijs Hollemans
//  Copyright © 2017 Swift Algorithm Club. All rights reserved.
//

// taken from https://github.com/raywenderlich/swift-algorithm-club/tree/master/Queue

import Foundation

public struct Queue<T> {
    fileprivate var array = [T?]()
    fileprivate var head = 0
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var count: Int {
        return array.count - head
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else { return nil }
        
        array[head] = nil
        head += 1
        
        let percentage = Double(head)/Double(array.count)
        if array.count > 50 && percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        
        return element
    }
    
    public var first: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
    
    public var last: T? {
        guard !isEmpty else {
            return nil
        }
        
        return array[array.count-1]
    }
}
