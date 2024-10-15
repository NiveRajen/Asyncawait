//
//  Model.swift
//  Asyncawait
//
//  Created by Nivedha Rajendran on 15.10.24.
//

struct SlowDivideOperation {
    
    let name: String
    let a: Double
    let b: Double
    let sleepDuration: UInt64
    
    func execute() async -> Double {
        
        // Sleep for x seconds
        await Task.sleep(sleepDuration * 1_000_000_000)
        
        let value = a / b
        return value
    }
}
