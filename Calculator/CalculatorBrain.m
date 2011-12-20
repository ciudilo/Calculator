//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Kiril Piskunov on 20/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain
@synthesize operandStack = _operandStack;

- (NSMutableArray*)operandStack
{
    if (_operandStack == Nil) _operandStack  = [[NSMutableArray alloc] init]; 
    return _operandStack;
}

- (double)popOperand
{
    NSNumber *operandObj = [self.operandStack lastObject];
    if (operandObj) [self.operandStack removeLastObject];
    return [operandObj doubleValue];
}

- (void)pushOperand:(double)operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString*)operation
{
    double result = 0;
    if ([operation isEqualToString:@"+"])
    {
        result = [self popOperand] + [self popOperand];
    }
    else if ([operation isEqualToString:@"*"])
    {
        result = [self  popOperand] * [self popOperand];
    }
    else if ([operation isEqualToString:@"/"])
    {
        double firstOperand = [self popOperand];
        double secondOperan = [self popOperand];
        
        result = secondOperan / firstOperand;
    }
    else if ([operation isEqualToString:@"-"])
    {
        double firstOperand = [self popOperand];
        double secondOperand = [self popOperand];
        
        result = secondOperand - firstOperand;
    }
    else if ([operation isEqualToString:@"sin"])
    {
        result = (double) sin ([self popOperand]);
    }
    else if ([operation isEqualToString:@"cos"])
    {
        result = (double) cos ([self popOperand]);
    }
    else if ([operation isEqualToString:@"sqrt"])
    {
        result = (double) sqrt ([self popOperand]);
    }
    else if ([operation isEqualToString:@"π"])
    {
        result = 3.14159;
    }
    
    [self pushOperand:result];
    
    return result;
}

- (void) clearBrain
{
    [self.operandStack removeAllObjects];
}

@end
