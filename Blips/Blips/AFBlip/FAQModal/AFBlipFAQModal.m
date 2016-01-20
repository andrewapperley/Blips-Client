//
//  AFBlipFAQModal.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-15.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipFAQModal.h"
#import "AFBlipFAQModalTableView.h"

@interface AFBlipFAQModal () <AFBlipFAQModalTableViewDatasource> {
    
    NSArray *_questionTextArray;
    NSArray *_answerTextArray;
}

@end

@implementation AFBlipFAQModal

#pragma mark - Init
- (instancetype)init {
    
    self = [super initWithToolbarWithTitle:[AFBlipFAQModal title] leftButton:nil rightButton:[AFBlipFAQModal rightButtonTitle]];
    if(self) {
        [self createBackground];
        [self createTableView];
    }
    return self;
}

- (void)createBackground {
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)createTableView {
    
    CGRect frame                       = CGRectMake(0, kAFBlipEditProfileToolbarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - kAFBlipEditProfileToolbarHeight);
    AFBlipFAQModalTableView *tableView = [[AFBlipFAQModalTableView alloc] initWithFrame:frame];
    tableView.autoresizingMask         = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    tableView.datasource               = self;
    [self.view addSubview:tableView];
}

#pragma mark - AFBlipFAQModalTableViewDatasource
- (NSArray *)questionTextArrayForFAQTable:(AFBlipFAQModalTableView *)FAQTable {
    
    if(!_questionTextArray) {
        
        _questionTextArray = @[NSLocalizedString(@"AFBLipFAQModalQuestion0", nil),
                               NSLocalizedString(@"AFBLipFAQModalQuestion1", nil),
                               NSLocalizedString(@"AFBLipFAQModalQuestion2", nil),
                               NSLocalizedString(@"AFBLipFAQModalQuestion3", nil),
                               NSLocalizedString(@"AFBLipFAQModalQuestion4", nil),
                               NSLocalizedString(@"AFBLipFAQModalQuestion5", nil),
                               NSLocalizedString(@"AFBLipFAQModalQuestion6", nil),
                               NSLocalizedString(@"AFBLipFAQModalQuestion7", nil),
                               NSLocalizedString(@"AFBLipFAQModalQuestion8", nil),
                               NSLocalizedString(@"AFBLipFAQModalQuestion9", nil)];
    }
    
    return _questionTextArray;
}

- (NSArray *)answerTextArrayForFAQTable:(AFBlipFAQModalTableView *)FAQTable {
    
    if(!_answerTextArray) {
        
        _answerTextArray = @[NSLocalizedString(@"AFBLipFAQModalAnswer0", nil),
                             NSLocalizedString(@"AFBLipFAQModalAnswer1", nil),
                             NSLocalizedString(@"AFBLipFAQModalAnswer2", nil),
                             NSLocalizedString(@"AFBLipFAQModalAnswer3", nil),
                             NSLocalizedString(@"AFBLipFAQModalAnswer4", nil),
                             NSLocalizedString(@"AFBLipFAQModalAnswer5", nil),
                             NSLocalizedString(@"AFBLipFAQModalAnswer6", nil),
                             NSLocalizedString(@"AFBLipFAQModalAnswer7", nil),
                             NSLocalizedString(@"AFBLipFAQModalAnswer8", nil),
                             NSLocalizedString(@"AFBLipFAQModalAnswer9", nil)];
    }
    
    return _answerTextArray;
}

#pragma mark - Button actions
- (void)rightButtonAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Utilities 
+ (NSString *)title {
    
    return NSLocalizedString(@"AFBLipFAQModalNavigationTitle", nil);
}

+ (NSString *)rightButtonTitle {
    
    return NSLocalizedString(@"AFBLipFAQModalCancelButtonTitle", nil);
}

@end