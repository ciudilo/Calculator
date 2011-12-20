//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Kiril Piskunov on 20/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;

@property (weak, nonatomic) IBOutlet UILabel *inputLog;

- (IBAction)digitPressed:(UIButton*)sender;

- (IBAction)operationPressed:(UIButton*)sender;

- (IBAction)enterPressed;

- (IBAction)clearPressed;
@end
