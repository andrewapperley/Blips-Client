//
//  AFBlipFAQModalTableViewCell.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-15.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipFAQModalTableViewCell.h"

#pragma mark - Constants
//Frames
const CGFloat kAFBlipFAQModalTableViewCell_CellPaddingTop            = 15.0f;
const CGFloat kAFBlipFAQModalTableViewCell_EstimatedRowHeight        = 80.0f;
const CGFloat kAFBlipFAQModalTableViewCell_HorizontalPadding         = 10.0f;
const CGFloat kAFBlipFAQModalTableViewCell_HorizontalPaddingQuestion = 30.0f;
const CGFloat kAFBlipFAQModalTableViewCell_TextPaddingBottom         = 3.0f;
const CGFloat kAFBlipFAQModalTableViewCell_QuestionPaddingTop        = 7.0f;

//Font size offsets
const CGFloat kAFBlipFAQModalTableViewCell_FontQ                     = 8.0f;
const CGFloat kAFBlipFAQModalTableViewCell_FontQuestion              = 1.0f;
const CGFloat kAFBlipFAQModalTableViewCell_FontAnswer                = 0.0f;

@interface AFBlipFAQModalTableViewCell () {
    
    UILabel *_qLabel;
    UILabel *_questionLabel;
    UILabel *_answerLabel;
}

@end

@implementation AFBlipFAQModalTableViewCell

#pragma mark - Init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self createBackground];
        [self createQLabel];
        [self createQuestionLabel];
        [self createAnswerLabel];
    }
    return self;
}

- (void)createBackground {
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = self.backgroundColor;
}

- (void)createQLabel {
    
    _qLabel               = [[UILabel alloc] init];
    _qLabel.textColor     = [UIColor afBlipPurpleTextColor];
    _qLabel.textAlignment = NSTextAlignmentRight;
    _qLabel.numberOfLines = 0;
    _qLabel.text          = NSLocalizedString(@"AFBLipFAQModalQuestionQ", nil);
    [self.contentView addSubview:_qLabel];
}

- (void)createQuestionLabel {
    
    _questionLabel               = [[UILabel alloc] init];
    _questionLabel.textColor     = [UIColor afBlipPurpleTextColor];
    _questionLabel.numberOfLines = 0;
    [self.contentView addSubview:_questionLabel];
}

- (void)createAnswerLabel {
    
    _answerLabel               = [[UILabel alloc] init];
    _answerLabel.textColor     = [UIColor grayColor];
    _answerLabel.numberOfLines = 0;
    [self.contentView addSubview:_answerLabel];
}

#pragma mark - Updates
- (void)updateWithQuestionText:(NSString *)questionText answerText:(NSString *)answerText {
    
    CGSize boundingRectSize = [AFBlipFAQModalTableViewCell boundingRectSizeForLabel];
    
    //Q
    _qLabel.font          = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:kAFBlipFAQModalTableViewCell_FontQ];
    [_qLabel sizeToFit];
    [self.contentView addSubview:_qLabel];
    
    CGRect qLabelFrame     = _qLabel.frame;
    qLabelFrame.origin.y   = kAFBlipFAQModalTableViewCell_CellPaddingTop;
    qLabelFrame.size.width = kAFBlipFAQModalTableViewCell_HorizontalPadding + kAFBlipFAQModalTableViewCell_HorizontalPaddingQuestion;
    _qLabel.frame          = qLabelFrame;
    
    //Question
    _questionLabel.font          = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:kAFBlipFAQModalTableViewCell_FontQuestion];

    NSDictionary *questionBoundingDictionary = @{NSFontAttributeName: _questionLabel.font};
    
    CGRect questionFrame   = [questionText boundingRectWithSize:boundingRectSize options:NSStringDrawingUsesLineFragmentOrigin attributes:questionBoundingDictionary context:nil];
    questionFrame.origin.x = kAFBlipFAQModalTableViewCell_HorizontalPaddingQuestion + kAFBlipFAQModalTableViewCell_HorizontalPadding;
    questionFrame.origin.y = kAFBlipFAQModalTableViewCell_CellPaddingTop + kAFBlipFAQModalTableViewCell_QuestionPaddingTop;
    _questionLabel.text    = questionText;
    _questionLabel.frame   = questionFrame;
    
    //Answer
    _answerLabel.font          = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:kAFBlipFAQModalTableViewCell_FontAnswer];

    NSDictionary *answerBoundingDictionary = @{NSFontAttributeName: _answerLabel.font};
    
    CGRect answerFrame   = [answerText boundingRectWithSize:boundingRectSize options:NSStringDrawingUsesLineFragmentOrigin attributes:answerBoundingDictionary context:nil];
    answerFrame.origin.x = questionFrame.origin.x;
    answerFrame.origin.y = CGRectGetMaxY(questionFrame) + kAFBlipFAQModalTableViewCell_TextPaddingBottom;
    _answerLabel.text    = answerText;
    _answerLabel.frame   = answerFrame;
}

#pragma mark - Prepare for reuse
- (void)prepareForReuse {
    [super prepareForReuse];

    _questionLabel.text = nil;
    _answerLabel.text   = nil;
}

#pragma mark - Height
+ (CGFloat)cellHeightForQuestionText:(NSString *)questionText answerText:(NSString *)answerText {
    
    CGSize boundingRectSize = [AFBlipFAQModalTableViewCell boundingRectSizeForLabel];
    
    //Question
    UILabel *questionLabel                   = [[UILabel alloc] init];
    questionLabel.font                       = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:kAFBlipFAQModalTableViewCell_FontQ];
    questionLabel.textColor                  = [UIColor afBlipModalHeaderBackgroundColor];
    questionLabel.numberOfLines              = 0;

    NSDictionary *questionBoundingDictionary = @{NSFontAttributeName:[UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:4]};

    CGRect questionFrame                     = [questionText boundingRectWithSize:boundingRectSize options:NSStringDrawingUsesLineFragmentOrigin attributes:questionBoundingDictionary context:nil];
    questionFrame.origin.y = kAFBlipFAQModalTableViewCell_CellPaddingTop + kAFBlipFAQModalTableViewCell_QuestionPaddingTop;
    questionLabel.text                       = questionText;
    questionLabel.frame                      = questionFrame;

    //Answer
    UILabel *answerLabel                     = [[UILabel alloc] init];
    answerLabel.font                         = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:kAFBlipFAQModalTableViewCell_FontQuestion];
    answerLabel.textColor                    = [UIColor lightGrayColor];
    answerLabel.numberOfLines                = 0;

    NSDictionary *answerBoundingDictionary   = @{NSFontAttributeName:[UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:kAFBlipFAQModalTableViewCell_FontAnswer]};

    CGRect answerFrame                       = [answerText boundingRectWithSize:boundingRectSize options:NSStringDrawingUsesLineFragmentOrigin attributes:answerBoundingDictionary context:nil];
    answerFrame.origin.y                     = CGRectGetMaxY(questionFrame) + kAFBlipFAQModalTableViewCell_TextPaddingBottom;
    answerLabel.text                         = answerText;
    answerLabel.frame                        = answerFrame;
    
    return CGRectGetMaxY(answerFrame);
}

+ (CGFloat)estimatedCellHeight {

    return kAFBlipFAQModalTableViewCell_EstimatedRowHeight;
}

+ (CGSize)boundingRectSizeForLabel {
    
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - kAFBlipFAQModalTableViewCell_HorizontalPaddingQuestion - (kAFBlipFAQModalTableViewCell_HorizontalPadding * 2), CGFLOAT_MAX);
}

@end