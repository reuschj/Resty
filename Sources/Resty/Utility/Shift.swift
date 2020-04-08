//
//  Shift.swift
//  Resty
//
//  Created by Justin Reusch on 4/5/20.
//

import Foundation

/**
 Errors that can be thrown by shift utility function
 */
enum ShiftError<Amount: SignedNumeric & Comparable>: Error, CustomStringConvertible {
    
    // ⚠️ Error cases --------------------------------------- /
    
    case inputAmountOutOfRange(amount: Amount, range: ClosedRange<Amount>)
    
    // 💻 Computed Properties --------------------------------- /
    
    var description: String {
        switch self {
        case .inputAmountOutOfRange(amount: let amount, range: let range):
            return "The input amount, \(amount), is out of range (\(range.lowerBound) to \(range.upperBound))."
        }
    }
}

/**
 * Utility to shifts an amount by a value, but keeps within the given range, wrapping around as many times as needed
 */
func shift<Amount: SignedNumeric & Comparable>(_ amount: Amount, by shiftAmount: Amount, within range: ClosedRange<Amount>) throws -> Amount {
    guard range.contains(amount) else { throw ShiftError.inputAmountOutOfRange(amount: amount, range: range) }
    let low = range.lowerBound
    let high = range.upperBound
    let sum: Amount = amount + shiftAmount
    let reversed: Bool = shiftAmount < 0
    var diff: Amount
    if reversed {
        diff = sum < low ? low - sum : 0
    } else {
        diff = sum > high ? sum - high : 0
    }
    if diff == 0 { return sum }
    if reversed {
        return try shift(high, by: -(diff - 1), within: range)
    } else {
        return try shift(low, by: diff - 1, within: range)
    }
}
