//
//  AFBlipFAQModalTableView.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-15.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipFAQModalTableView.h"
#import "AFBlipFAQModalTableViewCell.h"
#import "AFDynamicFontMediator.h"

#pragma mark - Constants
NSString *const kAFBlipFAQModalTableView_CellIdentifider   = @"kAFBlipFAQModalTableView_CellIdentifider";
NSString *const kAFBlipFAQModalTableView_FooterIdentifider = @"kAFBlipFAQModalTableView_FooterIdentifider";

@interface AFBlipFAQModalTableView () <UITableViewDelegate, UITableViewDataSource, AFDynamicFontMediatorDelegate> {
    
    AFDynamicFontMediator   *_dynamicFont;
    UITableView             *_tableView;
}

@end

@implementation AFBlipFAQModalTableView

#pragma mark - Init 
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        [self createTableView];
        [self createDynamicFont];
    }
    return self;
}

- (void)createDynamicFont {
    
    _dynamicFont = [[AFDynamicFontMediator alloc] init];
    _dynamicFont.delegate = self;
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator {
    
    [_tableView reloadData];
}

- (void)createTableView {
    
    _tableView                    = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.delegate           = self;
    _tableView.dataSource         = self;
    _tableView.allowsSelection    = NO;
    _tableView.autoresizingMask   = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.estimatedRowHeight = [AFBlipFAQModalTableViewCell estimatedCellHeight];
    _tableView.separatorStyle     = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor    = [UIColor whiteColor];
    _tableView.contentInset       = UIEdgeInsetsMake(0, 0, kAFBlipFAQModalTableViewCell_CellPaddingTop, 0);
    [_tableView registerClass:[AFBlipFAQModalTableViewCell class] forCellReuseIdentifier:kAFBlipFAQModalTableView_CellIdentifider];
    [self addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [AFBlipFAQModalTableViewCell estimatedCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *questionText = [self questionTextForIndexPath:indexPath];
    NSString *answerText   = [self answerTextForIndexPath:indexPath];
    
    return [AFBlipFAQModalTableViewCell cellHeightForQuestionText:questionText answerText:answerText];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return [self tableView:tableView estimatedHeightForHeaderInSection:section];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_datasource questionTextArrayForFAQTable:self].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AFBlipFAQModalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAFBlipFAQModalTableView_CellIdentifider];

    NSString *questionText            = [self questionTextForIndexPath:indexPath];
    NSString *answerText              = [self answerTextForIndexPath:indexPath];
    [cell updateWithQuestionText:questionText answerText:answerText];
    
    return cell;
}

#pragma mark - Data
- (NSString *)questionTextForIndexPath:(NSIndexPath *)indexPath {
    
    return [_datasource questionTextArrayForFAQTable:self][indexPath.row];
}

- (NSString *)answerTextForIndexPath:(NSIndexPath *)indexPath {
    
    return [_datasource answerTextArrayForFAQTable:self][indexPath.row];
}

#pragma mark - Dealloc
- (void)dealloc {
    _datasource = nil;
}

@end