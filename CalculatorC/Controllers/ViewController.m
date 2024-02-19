//
//  ViewController.m
//  CalculatorC
//
//  Created by Kevin Peng on 2019-11-01.
//  Copyright © 2019 Kevin Peng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) NSNumber *displayedNumber;
@property NSMutableArray<NSNumber *> *pendingOperations;
@property NSMutableArray<NSNumber *> *numbersForOperations;
@property bool isLastKeypressOperation;
@end

@implementation ViewController

- (void)setupUI
{
    self.view.backgroundColor = UIColor.systemBackgroundColor;

    UIView *left = [self makeLeftPortion];
    UIView *right = [self makeOperationButtons];

    UIStackView *topKeypadStack = UIStackView.new;
    topKeypadStack.spacing = 8;
    topKeypadStack.translatesAutoresizingMaskIntoConstraints = NO;

    [topKeypadStack addArrangedSubview:left];
    [topKeypadStack addArrangedSubview:right];

    UILabel *numberLabel = UILabel.new;
    numberLabel.textColor = UIColor.labelColor;
    numberLabel.font = [UIFont systemFontOfSize:70];
    numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:numberLabel];

    self.numberLabel = numberLabel;
    
    UIStackView *bottomKeypadStack = UIStackView.new;
    bottomKeypadStack.spacing = 8;
    bottomKeypadStack.distribution = UIStackViewDistributionFillEqually;

    UIButton *zeroButton = [self makeButton:@"0"];
    [bottomKeypadStack addArrangedSubview:zeroButton];

    UIButton *equalButton = [self makeOperationButton:@"🟰"];
    [bottomKeypadStack addArrangedSubview:equalButton];
    [equalButton addTarget:self action:@selector(equalButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    UIStackView *mainKeypadStack = UIStackView.new;
    mainKeypadStack.distribution = UIStackViewDistributionFillProportionally;
    mainKeypadStack.spacing = 8;
    mainKeypadStack.translatesAutoresizingMaskIntoConstraints = NO;
    mainKeypadStack.axis = UILayoutConstraintAxisVertical;
    [mainKeypadStack addArrangedSubview:topKeypadStack];
    [mainKeypadStack addArrangedSubview:bottomKeypadStack];

    [self.view addSubview:mainKeypadStack];

    [NSLayoutConstraint activateConstraints:@[
        [mainKeypadStack.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:8],
        [mainKeypadStack.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-8],
        [mainKeypadStack.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-8],
        [mainKeypadStack.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:0.7],
        [numberLabel.bottomAnchor constraintEqualToAnchor:mainKeypadStack.topAnchor constant:-8],
        [numberLabel.trailingAnchor constraintEqualToAnchor:mainKeypadStack.trailingAnchor],
        [right.widthAnchor constraintEqualToAnchor:mainKeypadStack.widthAnchor multiplier:0.25 constant:-8],
    ]];
}

- (UIView *)makeOperationButtons
{
    UIStackView *right = UIStackView.new;
    right.translatesAutoresizingMaskIntoConstraints = NO;
    right.distribution = UIStackViewDistributionFillEqually;
    right.spacing = 8;
    right.axis = UILayoutConstraintAxisVertical;

    NSArray *operationTags = @[@3, @2, @1, @0];
    NSArray *operationButtons = @[@"➗", @"✖️", @"➖", @"➕"];

    for (NSInteger i = 0; i < operationTags.count; i++) {
        NSString *symbol = operationButtons[i];
        NSNumber *tag = operationTags[i];
        UIButton *button = [self makeOperationButton:symbol];
        [button addTarget:self action:@selector(operationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = tag.intValue;
        [right addArrangedSubview:button];
    }
    return right;
}


- (UIView *)makeLeftPortion
{
    UIStackView *left = UIStackView.new;
    left.distribution = UIStackViewDistributionFillEqually;
    left.spacing = 8;
    left.translatesAutoresizingMaskIntoConstraints = NO;
    left.axis = UILayoutConstraintAxisVertical;
    UIStackView *currentRow = UIStackView.new;

    for (NSInteger i = 1; i < 10; i++) {
        NSString *title = [NSString stringWithFormat:@"%ld", i];

        UIButton *button = [self makeButton:title];
        button.tag = i;
        [button addTarget:self action:@selector(numberButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

        [currentRow addArrangedSubview:button];
        if (i % 3 == 0) {
            currentRow.distribution = UIStackViewDistributionFillEqually;
            currentRow.spacing = 8;
            [left insertArrangedSubview:currentRow atIndex:0];
            currentRow = UIStackView.new;
        }
    }

    currentRow = nil;


    UIButton *clearButton = [self makeButton:@"C"];
    [clearButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];

    [left insertArrangedSubview:clearButton atIndex:0];

    return left;
}

- (UIButton *)makeButton:(NSString *)title
{
    UIButton *button = UIButton.new;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button setTitleColor:UIColor.systemRedColor forState:UIControlStateHighlighted];
    button.backgroundColor = UIColor.darkGrayColor;
    [button.layer setBorderWidth:1];
    [button.layer setCornerRadius:5];
    return button;
}

- (UIButton *)makeOperationButton:(NSString *)title
{
    UIButton *button = [self makeButton:title];
    button.backgroundColor = UIColor.lightGrayColor;
    return button;
}

- (void)setDisplayedNumber:(NSNumber *)displayedNumber
{
    _displayedNumber = displayedNumber;
    self.numberLabel.text = displayedNumber.stringValue;
}

- (void)clearMemory {
    [_pendingOperations removeAllObjects];
    [_numbersForOperations removeAllObjects];
    _isLastKeypressOperation = NO;
    self.displayedNumber = @0;
}

- (void)clear:(id)sender {
    [self clearMemory];
}

- (NSNumber *)stringToNumber:(NSString *)string {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    return (NSNumber *) [f numberFromString:string];
}

- (void)numberButtonPressed:(id)sender {
    if (_isLastKeypressOperation) {
        self.displayedNumber = [NSNumber numberWithInt:0];
    }
    UIButton *buttonPressed = (UIButton*) sender;
    NSString *string = [self.displayedNumber stringValue];
    NSString *newInput = [[NSNumber numberWithLong:buttonPressed.tag] stringValue];
    string = [string stringByAppendingString: newInput];

    NSNumber *newNumber = [self stringToNumber:string];
    self.displayedNumber = newNumber;
    _isLastKeypressOperation = NO;
}

- (void)equalButtonPressed:(id)sender {
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
    self.displayedNumber = temp;
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

- (void)operationButtonPressed:(id)sender {
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
    [self setupUI];
    [self clear:nil];
}


@end
