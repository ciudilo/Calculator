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
+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)program;
+ (BOOL)isOperation:(NSString *)operation;
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

- (void)pushOperand:(double)operand;
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString*)variable
{
    [self.programStack addObject:variable];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    NSString *result = [self descriptionOfTopOfStack:stack];
    result = [result stringByAppendingString:@" "];
    
    if ([stack count] > 0)
    {
        result = [result stringByAppendingString:[self descriptionOfProgram:stack]];
    }
                                
    return result;
}

+ (BOOL)isOperation:(NSString *)operation
{
    
    
    return YES;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)program
{
    NSString *result;
    
    NSSet *twoOperandOps = [[NSSet alloc] initWithObjects:@"+", @"-", @"*", @"/", nil];
    NSSet *singleOperandOps = [[NSSet alloc] initWithObjects:@"sqrt", @"cos", @"sin", nil];

    id topOfStack = [program lastObject];
    if (topOfStack) [program removeLastObject];
    
    if ( [twoOperandOps containsObject:topOfStack])
    {
        NSString *operand = [NSString stringWithFormat:@"%@", topOfStack];  
        NSString *operation = [NSString stringWithFormat:@"%@ %@ %@",
                  [self descriptionOfTopOfStack:program], operand, [self descriptionOfTopOfStack:program]];
        result = [NSString stringWithFormat:@"%@%@%@", @"(", operation, @")"];        
    }
    else if ([singleOperandOps containsObject:topOfStack])
    {
        NSString *operand = [NSString stringWithFormat:@"%@", topOfStack];
        result = [operand stringByAppendingFormat:@"%@%@%@", 
                  @"(", [self descriptionOfTopOfStack:program], @")"];    }
    else
    {
        NSLog(@"Top of the stack: %@", topOfStack);
        
        result = [NSString stringWithFormat:@"%@", topOfStack];
    }
    
    return result;
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
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
            NSLog(@"Operation element on the stack.");
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        }
        else if ([operation isEqualToString:@"*"])
        {
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        }
        else if ([operation isEqualToString:@"/"])
        {
            double firstOperand = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] / firstOperand;
        }
        else if ([operation isEqualToString:@"-"])
        {
            double firstOperand = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - firstOperand;
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
    
    NSLog(@"Pesult pop top of the stack: %g", result);
    
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

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    NSSet *variables = [CalculatorBrain variablesUsedInProgram:stack];
    
    NSLog(@"Varaibles set size: %d", [variables count]);
    NSLog(@"Passed in varaibles dict size: %d", [variableValues count]);
    
    for (int i = 0; i < [stack count]; i++) {
        NSObject *operand = [stack objectAtIndex:i];
        if( [operand isKindOfClass:[NSString class]] && [variables containsObject:operand])
        {            
            NSNumber *varValue = [variableValues objectForKey:operand];
            if (varValue != Nil)
            {
                NSLog(@"Replacing variable %@ with: %@", operand, varValue);
                [stack replaceObjectAtIndex:i withObject:varValue];
            }
            else
            {
                [stack replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:0]];
            }
        }
    }
    
    
    return [CalculatorBrain runProgram:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSSet *twoOperandOps = [[NSSet alloc] initWithObjects:@"+", @"-", @"*", @"/", nil];
    NSSet *singleOperandOps = [[NSSet alloc] initWithObjects:@"sqrt", @"cos", @"sin", nil];
    
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    NSMutableArray *variables = [[NSMutableArray alloc] init];
    for (NSString *string in stack)
    {
        if( ![string doubleValue] && ![twoOperandOps member:string] && ![singleOperandOps member:string]
           && ![@"π" isEqualToString:string]) // if opernad is not a number and not operation
        {
            [variables addObject:string];
            NSLog(@"Added variable to the list: %@", string);
        }
    }
    
    if ([variables count] > 0) {
        return [[NSSet alloc] initWithArray:variables];
    }
    else
    {
        return Nil;
    }
    
    
}

- (void) clearBrain
{
    [self.programStack removeAllObjects];
}

@end
