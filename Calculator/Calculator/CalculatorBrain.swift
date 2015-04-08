//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Guang Yang on 2015-04-01.
//  Copyright (c) 2015 Guang Yang. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op : Printable {//this is not inheritance, this is protocal
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double,Double) ->Double)
        
        var description : String {
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
            //this is read-only so it doesnt have setter
        }
    }
    
    private var stack = [Op]()
    private var knownOps = [String:Op]()
    
    //here comes the swift type of initializer
    //this is called by: let brain = CalculatorBrian()
    init(){
        func learnOps(op: Op){
            knownOps[op.description] = op
        }
        learnOps(Op.BinaryOperation("+", +))
        learnOps(Op.BinaryOperation("-", -))
        learnOps(Op.BinaryOperation("*") {$0 * $1})
        learnOps(Op.BinaryOperation("/") {$0 / $1})
        learnOps(Op.UnaryOperation("√",sqrt))
    }
    
    typealias PropertyList = AnyObject
    var program : PropertyList { //Garanteed to be a property list
        get{
            return stack.map{$0.description}
        }
        set{
            if let opSymbols = newValue as? [String]{
                var newStack = [Op]()
                for opSymbol in opSymbols{
                    if let op = knownOps[opSymbol]{
                        newStack.append(op)
                    }
                    else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue{
                        newStack.append(.Operand(operand))
                    }
                }
                stack = newStack
            }
        }
    }
    
    //tuple -> mini data structure that contains the return value
    //var ops: [Op] <- makes the array copy mutable
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch(op){
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):// _ means "I don't care"
                //recursion
                //call a function that returns a tuple
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_ , let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let op1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let op2 = op2Evaluation.result{
                        return (operation(op1, op2), op2Evaluation.remainingOps)
                    }
                }
                
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? { // it is optional because sometime the value cannot be calculated
        let (result, remainder) = evaluate(stack)
        return result
    }
    
    func pushOperand(operand : Double) -> Double?{
        stack.append(Op.Operand(operand)) //<- this is the way to create an enum object
        return evaluate()
    }
    
    func performOperation(symbol: String) ->Double?{
        if let operation = knownOps[symbol]{ //it is optional because the value might be nil (cannot found)
            stack.append(operation)
        }
        return evaluate()
    }
}