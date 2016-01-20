//
//  AFBlipFAQModalTableViewCell.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-15.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT const CGFloat kAFBlipFAQModalTableViewCell_CellPaddingTop;

@interface AFBlipFAQModalTableViewCell : UITableViewCell

#pragma mark - Updates
- (void)updateWithQuestionText:(NSString *)questionText answerText:(NSString *)answerText;

#pragma mark - Height
+ (CGFloat)cellHeightForQuestionText:(NSString *)questionText answerText:(NSString *)answerText;
+ (CGFloat)estimatedCellHeight;

@end