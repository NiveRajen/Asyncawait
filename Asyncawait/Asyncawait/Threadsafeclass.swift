//
//  Model.swift
//  Asyncawait
//
//  Created by Nivedha Rajendran on 15.10.24.
//

//declaring actor instead of class - this will prevent from racing conditions
actor Counter {
    private var value = 0
    func increment() {
        value += 1
    }
    func getValue() -> Int {
        return value
    }
}
