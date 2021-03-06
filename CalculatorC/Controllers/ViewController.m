//
//  ViewController.m
//  CalculatorC
//
//  Created by Kevin Peng on 2019-11-01.
//  Copyright © 2019 Kevin Peng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property NSNumber *displayedNumber;
@property NSMutableArray<NSNumber *> *pendingOperations;
@property NSMutableArray<NSNumber *> *numbersForOperations;
@property bool isLastKeypressOperation;
@end

@implementation ViewController

- (void)updateDisplay:(NSNumber *)number {
    _displayedNumber = number;
    _numberLabel.text = [_displayedNumber stringValue];
}

- (void)clearMemory {
    [_pendingOperations removeAllObjects];
    [_numbersForOperations removeAllObjects];
    _isLastKeypressOperation = NO;
    _displayedNumber = [NSNumber numberWithInt:0];
}

- (IBAction)clear:(id)sender {
    _displayedNumber = [NSNumber numberWithInt:0];
    [self clearMemory];
    [self updateDisplay:[NSNumber numberWithInt:0]];
}

- (NSNumber *)stringToNumber:(NSString *)string {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    return (NSNumber *) [f numberFromString:string];
}

- (IBAction)numberButtonPressed:(id)sender {
    if (_isLastKeypressOperation) {
        _displayedNumber = [NSNumber numberWithInt:0];
    }
    UIButton *buttonPressed = (UIButton*) sender;
    NSString *string = [_displayedNumber stringValue];
    NSString *newInput = [[NSNumber numberWithLong:buttonPressed.tag] stringValue];
    string = [string stringByAppendingString: newInput];

    NSNumber *newNumber = [self stringToNumber:string];
    [self updateDisplay:newNumber];
    _isLastKeypressOperation = NO;
}

- (IBAction)equalButtonPressed:(id)sender {
    if (_numbersForOperations.count == 0) { return; }
    [_numbersForOperations addObject:_displayedNumber];
    NSNumber *temp = [_numbersForOperations firstObject];
    for (int i = 0; i < _numbersForOperations.count - 1; i++) {
        int operation = [_pendingOperations[i] intValue];
        NSNumber *secondNumber = _numbersForOperations[i + 1];
        temp = [self calculateAnswer:temp
                       withOperation:operation
                           andSecond:secondNumber];
    }
    [self updateDisplay:temp];
    [self clearMemory];
}

- (NSNumber *)calculateAnswer:(NSNumber *)first withOperation:(int)operation andSecond:(NSNumber *)second {
    switch (operation) {
        case 0:
            return [NSNumber numberWithDouble: [first doubleValue] + [second doubleValue]];
        case 1:
            return [NSNumber numberWithDouble: [first doubleValue] - [second doubleValue]];
        case 2:
            return [NSNumber numberWithDouble: [first doubleValue] * [second doubleValue]];
        case 3:
            return [NSNumber numberWithDouble: [first doubleValue] / [second doubleValue]];
        default:
            return 0;
    }
}

- (IBAction)operationButtonPressed:(id)sender {
    UIButton *buttonPressed = (UIButton*) sender;
    
    if (_pendingOperations == nil) {
        _pendingOperations = [[NSMutableArray<NSNumber *> alloc] init];
    }
    
    if (_isLastKeypressOperation) {
        [_pendingOperations removeLastObject];
    } else {
        if (_numbersForOperations == nil) {
            _numbersForOperations = [[NSMutableArray<NSNumber *> alloc] init];
        }
        _isLastKeypressOperation = YES;
        [_numbersForOperations addObject:_displayedNumber];
    }
    [_pendingOperations addObject:[NSNumber numberWithLong:buttonPressed.tag]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self clear:nil];
}


@end
