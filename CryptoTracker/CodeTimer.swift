//
//  CodeTimer.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 11/2/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import Foundation
import UIKit


class CodeTimer {
    
    static let timer = CodeTimer()
    
    var time: Date = Date()
    
    static func set() {
        CodeTimer.timer.time = Date()
    }
    static func finish(_ message: String = "") {
        let end = Date()
        let interval = end.timeIntervalSince(CodeTimer.timer.time)
        print(message + " \(interval)")
    }
    
    
    
}
class Random {
    
    static func random(from: Int, to: Int) -> Int {
        let number: Int = Int(arc4random_uniform(to - from + 1) + from)
        return number
    }
    static func random(fromZero to: Int) -> Int {
        return random(from: 0, to: to)
    }
    
    
    
}
