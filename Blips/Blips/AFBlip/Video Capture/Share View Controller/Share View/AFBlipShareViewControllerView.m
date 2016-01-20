//
//  AFBlipShareViewControllerView.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-07.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipAWSS3AbstractFactory.h"
#import "AFBlipShareViewControllerView.h"
#import "AFBlipUserModel.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipVideoTimelineModel.h"
#import "AFDynamicFontMediator.h"
#import "UIImageView+AFBlipImageView.h"

#pragma mark - Constants
//Profile
const CGFloat kAFBlipShareViewControllerViewProfileWidth                  = 90.0f;
const CGFloat kAFBlipShareViewControllerViewProfilePaddingTop             = 60.0f;

const CGFloat kAFBlipShareViewControllerViewLabelPaddingHorizontal        = 12.0f;
const CGFloat kAFBlipShareViewControllerViewLabelPaddingTop               = 5.0f;
const CGFloat kAFBlipShareViewControllerViewLabelProfileNameSizeOffset    = 1.0f;

//Message
const CGFloat kAFBlipShareViewControllerViewLabelMessageTitlePaddingTop   = 225.0f;
const CGFloat kAFBlipShareViewControllerViewLabelMessageTitleSizeOffset   = 2.0f;
const CGFloat kAFBlipShareViewControllerViewLabelMessageSizeOffset        = 0.0f;
const CGFloat kAFBlipShareViewControllerViewLabelMessagePaddingHorizontal = 10.0f;
const CGFloat kAFBlipShareViewControllerViewLabelMessagePaddingBottom     = 85.0f;
const CGFloat kAFBlipShareViewControllerViewLabelMessageCornerRadius      = 5.0f;

//Total characters
const NSUInteger kAFBlipShareViewControllerViewLabelMessageTotalCharacters = 135;

@interface AFBlipShareViewControllerView () <AFDynamicFontMediatorDelegate, UITextViewDelegate> {
    
    UITapGestureRecognizer  *_tapGesture;
    
    CGFloat                 _keyboardHeight;
    UIScrollView            *_scrollView;
    
    UILabel                 *_userLabel;
    UILabel                 *_friendLabel;
    AFDynamicFontMediator   *_fontMediator;
    UILabel                 *_messageTitle;
    UITextView              *_textField;
}

@end

@implementation AFBlipShareViewControllerView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame videoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel message:(NSString *)message {
    self = [super initWithFrame:frame];
    if(self) {
        
        [self createScrollView];
        [self createProfileImageViewsWithVideoTimelineModel:videoTimelineModel];
        [self createGesture];
        [self createMessageField:message];
        [self createNotifications];
        [self createFontMediator];
    }
    return self;
}

- (void)createScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_scrollView];
}

- (void)createProfileImageViewsWithVideoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel {

    CGRect profileImageViewFrame;
    
    //User
    AFBlipUserModel *userModel     = [AFBlipUserModelSingleton sharedUserModel].userModel;
    NSString *userImageURLString   = userModel.userImageUrl;
    NSString *userName             = userModel.displayName;

    UIImageView *userImageView     = [self profileImageViewWithImageURLString:userImageURLString];
    [_scrollView addSubview:userImageView];
    
    profileImageViewFrame          = userImageView.frame;
    profileImageViewFrame.origin.x = kAFBlipShareViewControllerViewLabelPaddingHorizontal * 2;
    userImageView.frame            = profileImageViewFrame;
    
    _userLabel = [self profileImageViewTextLabelWithString:userName profileImageView:userImageView];
    [_scrollView addSubview:_userLabel];
    
    //Friend
    NSString *friendImageURLString = videoTimelineModel.timelineFriendImageURLString;
    NSString *friendName           = videoTimelineModel.timelineTitle;
    
    UIImageView *friendImageView   = [self profileImageViewWithImageURLString:friendImageURLString];
    [_scrollView addSubview:friendImageView];
    
    profileImageViewFrame          = friendImageView.frame;
    profileImageViewFrame.origin.x = CGRectGetWidth(self.bounds) - CGRectGetWidth(profileImageViewFrame) - kAFBlipShareViewControllerViewLabelPaddingHorizontal * 2;
    friendImageView.frame          = profileImageViewFrame;
    
    _friendLabel = [self profileImageViewTextLabelWithString:friendName profileImageView:friendImageView];
    [_scrollView addSubview:_friendLabel];
    
    //Arrow
    UIImageView *arrowImageView    = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_share_arrow"]];
    
    CGRect arrowImageViewFrame     = arrowImageView.frame;
    arrowImageViewFrame.origin.x   = (CGRectGetWidth(self.bounds) - CGRectGetWidth(arrowImageViewFrame)) / 2;
    arrowImageViewFrame.origin.y   = (CGRectGetHeight(userImageView.frame) - CGRectGetHeight(arrowImageViewFrame)) / 2 + CGRectGetMinY(userImageView.frame);
    arrowImageView.frame           = arrowImageViewFrame;
    
    [_scrollView addSubview:arrowImageView];
}

- (UIImageView *)profileImageViewWithImageURLString:(NSString *)imageURLString {
    
    UIImageView __block *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kAFBlipShareViewControllerViewProfilePaddingTop, kAFBlipShareViewControllerViewProfileWidth, kAFBlipShareViewControllerViewProfileWidth)];
    
    imageView.backgroundColor       = [UIColor clearColor];
    imageView.contentMode           = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds         = YES;
    imageView.layer.cornerRadius    = imageView.frame.size.width * 0.5;
    imageView.layer.borderColor     = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth     = 2.0f;

    //Load image
    AFBlipAWSS3AbstractFactory *imageFactory = [AFBlipAWSS3AbstractFactory sharedAWS3Factory];
    [imageFactory objectForKey:imageURLString completion:^(NSData *data) {
        UIImage *image = [UIImage  imageWithData:data];
        [imageView setImage:image animated:YES];
    } failure:^(NSError *error) {
        
    }];
    
    return imageView;
}

- (UILabel *)profileImageViewTextLabelWithString:(NSString *)string profileImageView:(UIImageView *)profileImageView {
    
    UILabel *label      = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(profileImageView.frame) - kAFBlipShareViewControllerViewLabelPaddingHorizontal, CGRectGetMaxY(profileImageView.frame) + kAFBlipShareViewControllerViewLabelPaddingTop, 0, 0)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor     = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text          = string;
    
    return label;
}

- (void)createGesture {
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onKeyboardHide:)];
    _tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:_tapGesture];
    _tapGesture.enabled = NO;
}

- (void)createMessageField:(NSString *)message  {
    
    BOOL placeholder = !message || !message.length;
    
    //Message title
    _messageTitle               = [[UILabel alloc] initWithFrame:CGRectMake(0, kAFBlipShareViewControllerViewLabelMessageTitlePaddingTop, CGRectGetWidth(self.bounds), 40.0f)];
    _messageTitle.textAlignment = NSTextAlignmentCenter;
    _messageTitle.textColor     = [UIColor whiteColor];
    _messageTitle.text          = NSLocalizedString(@"AFBlipVideoViewShareMessageTitle", nil);;
    [_scrollView addSubview:_messageTitle];
    
    //Textfield
    CGFloat textFieldHeight       = CGRectGetHeight(self.bounds) - CGRectGetMaxY(_messageTitle.frame) - kAFBlipShareViewControllerViewLabelMessagePaddingBottom;
    
    _textField                    = [[UITextView alloc] initWithFrame:CGRectMake(kAFBlipShareViewControllerViewLabelMessagePaddingHorizontal, CGRectGetMaxY(_messageTitle.frame), CGRectGetWidth(self.bounds) - (kAFBlipShareViewControllerViewLabelMessagePaddingHorizontal * 2), textFieldHeight)];
    _textField.delegate           = self;
    _textField.backgroundColor    = [UIColor whiteColor];
    _textField.layer.cornerRadius = kAFBlipShareViewControllerViewLabelMessageCornerRadius;
    _textField.keyboardAppearance = UIKeyboardAppearanceDark;
    _textField.textContainerInset = UIEdgeInsetsMake(kAFBlipShareViewControllerViewLabelMessagePaddingHorizontal, kAFBlipShareViewControllerViewLabelMessagePaddingHorizontal, kAFBlipShareViewControllerViewLabelMessagePaddingHorizontal, kAFBlipShareViewControllerViewLabelMessagePaddingHorizontal);
    
    [self setTextfieldPlaceholderText:placeholder];
    
    if(!placeholder) {
        _textField.text = message;
    }
    
    [_scrollView addSubview:_textField];
}

- (void)setTextfieldPlaceholderText:(BOOL)placeholder {
    
    UIColor *color;
    NSString *text = _textField.text;
    
    if(placeholder) {
        color = [UIColor lightGrayColor];
        text  = NSLocalizedString(@"AFBlipVideoViewShareMessagePlaceholder", nil);
    } else {
        color = [UIColor grayColor];
        
        if([text isEqualToString:NSLocalizedString(@"AFBlipVideoViewShareMessagePlaceholder", nil)]) {
            text  = @"";
        }
    }
    
    _textField.textColor = color;
    _textField.text      = text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSInteger currentLength = [textView.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSInteger rangeLength = [text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger newLength = currentLength + range.length + rangeLength;
    
    return newLength < kAFBlipShareViewControllerViewLabelMessageTotalCharacters;
}

- (void)createNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)createFontMediator {
    
    _fontMediator          = [[AFDynamicFontMediator alloc] init];
    _fontMediator.delegate = self;
    [_fontMediator updateFontSize];
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator {
    
    //User
    _userLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:kAFBlipShareViewControllerViewLabelProfileNameSizeOffset];
    
    CGRect userLabelBoundingRect      = [_userLabel.text boundingRectWithSize:CGSizeMake(kAFBlipShareViewControllerViewProfileWidth + (kAFBlipShareViewControllerViewLabelPaddingHorizontal * 2), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _userLabel.font} context:nil];
    
    CGRect userLabelFrame             = _userLabel.frame;
    userLabelFrame.size.width         = kAFBlipShareViewControllerViewProfileWidth + (kAFBlipShareViewControllerViewLabelPaddingHorizontal * 2);
    userLabelFrame.size.height        = CGRectGetHeight(userLabelBoundingRect);
    _userLabel.frame                  = userLabelFrame;

    //Friend
    _friendLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:kAFBlipShareViewControllerViewLabelProfileNameSizeOffset];

    CGRect friendLabelBoundingRect     = [_friendLabel.text boundingRectWithSize:CGSizeMake(kAFBlipShareViewControllerViewProfileWidth + (kAFBlipShareViewControllerViewLabelPaddingHorizontal * 2), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _friendLabel.font} context:nil];
    
    CGRect friendLabelFrame             = _friendLabel.frame;
    friendLabelFrame.size.width         = kAFBlipShareViewControllerViewProfileWidth + (kAFBlipShareViewControllerViewLabelPaddingHorizontal * 2);
    friendLabelFrame.size.height        = CGRectGetHeight(friendLabelBoundingRect);
    _friendLabel.frame                  = friendLabelFrame;
    
    //Message
    _messageTitle.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:kAFBlipShareViewControllerViewLabelMessageTitleSizeOffset];
    _textField.font    = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:kAFBlipShareViewControllerViewLabelMessageSizeOffset];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if(_keyboardHeight > 0) {
        [_scrollView setContentOffset:CGPointMake(0, _keyboardHeight) animated:YES];
    }
    
    [self setTextfieldPlaceholderText:NO];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [_scrollView setContentOffset:CGPointZero animated:YES];
    
    BOOL placeholder = !_textField.text.length || [_textField.text isEqualToString:NSLocalizedString(@"AFBlipVideoViewShareMessagePlaceholder", nil)];
    
    [self setTextfieldPlaceholderText:placeholder];
}

- (void)textViewDidChange:(UITextView *)textView {
    
    BOOL placeholder = [_textField.text isEqualToString:NSLocalizedString(@"AFBlipVideoViewShareMessagePlaceholder", nil)];
    
    [self setTextfieldPlaceholderText:placeholder];
}

- (void)onKeyboardShow:(NSNotification *)notification {
    
    _tapGesture.enabled = YES;
    NSDictionary *notifictionDictionary = notification.userInfo;
    _keyboardHeight                     = CGRectGetHeight([notifictionDictionary[UIKeyboardFrameEndUserInfoKey] CGRectValue]);
}

- (void)onKeyboardHide:(NSNotification *)notification {
    
    _tapGesture.enabled = NO;
    [_textField resignFirstResponder];
    [_scrollView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - Message
- (NSString *)message {
    
    BOOL placeholder = !_textField.text.length || [_textField.text isEqualToString:NSLocalizedString(@"AFBlipVideoViewShareMessagePlaceholder", nil)];
    NSString *message = placeholder ? nil : _textField.text;

    return message;
}

#pragma mark - Dealloc
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end