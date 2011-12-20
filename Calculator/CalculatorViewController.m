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
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize inputLog = _inputLog;
@synthesize userInTheMiddleOfTypingANumber = _userInTheMiddleOfTypingANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = sender.currentTitle;

    if (self.userInTheMiddleOfTypingANumber) 
    {
        //makes sure that if user presses . digit more then once consecutive presses are ignored
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
    
    self.inputLog.text = [self.inputLog.text stringByAppendingString:@" "];
    self.inputLog.text = [self.inputLog.text stringByAppendingString:sender.currentTitle];
    self.inputLog.text = [self.inputLog.text stringByAppendingString:@" "];
    
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
}

- (IBAction)enterPressed 
{
    self.inputLog.text = [self.inputLog.text stringByAppendingString:@" "];
    self.inputLog.text = [self.inputLog.text stringByAppendingString:self.display.text];

    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userInTheMiddleOfTypingANumber = NO;
}

- (IBAction)clearPressed 
{
    self.inputLog.text = @"";
    self.display.text = @"";
    [self.brain clearBrain];
}

@end
