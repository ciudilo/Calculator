//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Kiril Piskunov on 20/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain
@synthesize programStack = _programStack;

- (NSMutableArray*)programStack
{
    if (_programStack == Nil) _programStack  = [[NSMutableArray alloc] init]; 
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement this in Homework #2";
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"+"])
        {
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        }
        else if ([operation isEqualToString:@"*"])
        {
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        }
        else if ([operation isEqualToString:@"/"])
        {
            double firstOperand = [self popOperandOffProgramStack:stack];
            double secondOperan = [self popOperandOffProgramStack:stack];
            
            result = secondOperan / firstOperand;
        }
        else if ([operation isEqualToString:@"-"])
        {
            double firstOperand = [self popOperandOffProgramStack:stack];
            double secondOperand = [self popOperandOffProgramStack:stack];
            
            result = secondOperand - firstOperand;
        }
        else if ([operation isEqualToString:@"sin"])
        {
            result = (double) sin ([self popOperandOffProgramStack:stack]);
        }
        else if ([operation isEqualToString:@"cos"])
        {
            result = (double) cos ([self popOperandOffProgramStack:stack]);
        }
        else if ([operation isEqualToString:@"sqrt"])
        {
            result = (double) sqrt ([self popOperandOffProgramStack:stack]);
        }
        else if ([operation isEqualToString:@"π"])
        {
            result = 3.14159;
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

- (void) clearBrain
{
    [self.programStack removeAllObjects];
}

@end
