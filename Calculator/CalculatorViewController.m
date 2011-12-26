//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Kiril Piskunov on 20/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userInTheMiddleOfTypingANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize inputLog = _inputLog;
@synthesize userInTheMiddleOfTypingANumber = _userInTheMiddleOfTypingANumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (NSDictionary *)testVariableValues
{
    if (!_testVariableValues) _testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     [NSNumber numberWithDouble:33], @"x", 
                                                     [NSNumber numberWithDouble:55], @"a",
                                                     [NSNumber numberWithDouble:77], @"b",
                                                     nil];
    return _testVariableValues;
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = sender.currentTitle;

    if (self.userInTheMiddleOfTypingANumber) 
    {
        //makes sure that if user presses '.' digit more then once, consecutive presses are ignored
        if ( [digit isEqualToString:@"."] && [self.display.text rangeOfString:@"."].location == NSNotFound) 
        {
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
        else if( ![digit isEqualToString:@"."])
        {
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
        
    }
    else
    {
        self.display.text = digit;
        self.userInTheMiddleOfTypingANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if (self.userInTheMiddleOfTypingANumber) [self enterPressed];
    
    double result = [self.brain performOperation:sender.currentTitle];
    
    self.inputLog.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
}

- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    self.inputLog.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    
    self.userInTheMiddleOfTypingANumber = NO;
}

- (IBAction)variablePressed:(UIButton*)sender 
{
    if (self.userInTheMiddleOfTypingANumber) [self enterPressed];
    
    [self.brain pushVariable:[sender currentTitle]];
     
    self.inputLog.text = [CalculatorBrain descriptionOfProgram:self.brain.program];

    self.display.text = [sender currentTitle];
}

- (IBAction)clearPressed 
{
    self.inputLog.text = @"";
    self.display.text = @"";
    [self.brain clearBrain];
}

- (IBAction)testButtonPressed:(UIButton *)sender
{
    if (self.userInTheMiddleOfTypingANumber) [self enterPressed];
    
    double result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    self.inputLog.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
}

@end
