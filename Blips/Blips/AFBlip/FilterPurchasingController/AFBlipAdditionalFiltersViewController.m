//
//  AFBlipAdditionalFiltersViewController.m
//  Blips
//
//  Created by Andrew Apperley on 2014-09-22.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipAdditionalFiltersViewController.h"
#import "AFBlipGalleryObject.h"
#import "AFBlipGalleryViewController.h"
#import <StoreKit/StoreKit.h>
#import "AFBlipStoreKitManager.h"
#import "AFBlipActivityIndicator.h"
#import "AFBlipAlertView.h"

const NSString *kAFBlipAdditionalFiltersPrefix              = @"AFBlipAdditionalFilters_";
const NSString *kAFBlipAdditionalFilterssProduct            = @"afBlipsAdditionalVideoFilters";
const CGFloat kAFBlipAdditionalFiltersGalleryPosY           = 75.0f;
const CGFloat kAFBlipAdditionalFiltersGallerySizeWidth      = 300.0f;
const CGFloat kAFBlipAdditionalFiltersGallerySizeHeight     = 330.0f;

//Submit button
const CGFloat kAFBlipAdditionalFilters_SubmitButtonPaddingX        = 25.0f;
const CGFloat kAFBlipAdditionalFilters_SubmitButtonHeight          = 44.0f;
const CGFloat kAFBlipAdditionalFilters_SubmitButtonWhiteAlpha      = 0.1f;
const CGFloat kAFBlipAdditionalFilters_SubmitButtonBorderWidth     = 1.0f;
const CGFloat kAFBlipAdditionalFilters_HorizontalPadding           = 25.0f;

const CGFloat kAFBlipAdditionalFiltersDescriptionYOffset    = 20.0f;

@interface AFBlipAdditionalFiltersViewController () <SKProductsRequestDelegate> {
    SKProduct *_filterPackProduct;
    AFBlipGalleryViewController *_filterGallery;
    UIButton *_submitButton;
    UILabel *_filterDescriptionLabel;
    AFBlipAdditionalFiltersLoadedBlock _loaded;
    AFBlipAdditionalFiltersTransactionComplete _complete;
    BOOL _restore;
    AFBlipActivityIndicator *_activityIndicator;
    UIScrollView *_contentScrollView;
}

@end

@implementation AFBlipAdditionalFiltersViewController

- (instancetype)initWithToolbarWithTitle:(NSString *)title leftButton:(NSString *)leftButtonTitle rightButton:(NSString *)rightButtonTitle loadedBlock:(AFBlipAdditionalFiltersLoadedBlock)loaded transactionComplete:(AFBlipAdditionalFiltersTransactionComplete)completion {
    if (self = [super initWithToolbarWithTitle:title leftButton:leftButtonTitle rightButton:rightButtonTitle]) {
        _loaded = loaded;
        _complete = completion;
        SKProductsRequest *storeKitRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kAFBlipAdditionalFilterssProduct]];
        storeKitRequest.delegate = self;
        [storeKitRequest start];
    }
    return self;
}

- (void)leftButtonAction {
    [self dismissView];
}

static NSArray * filterList(void) {
    return @[@"Recit", @"Hexaplar", @"Universitat", @"Nomad", @"Fuellert", @"Elysian", @"Realm", @"Apperley", @"Beatnik", @"X-Force", @"Fall"];
}

- (void)createContentView {
    _contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _contentScrollView.showsVerticalScrollIndicator = NO;
    [self.view insertSubview:_contentScrollView atIndex:self.view.subviews.count-2];
}

- (void)createFilterGallery {
    NSMutableArray *galleryObjects = [[NSMutableArray alloc] init];
    for (NSString *filterName in filterList()) {
        AFBlipGalleryObject *object = [[AFBlipGalleryObject alloc] init];
        object.objectTitle = filterName;
        object.objectImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", kAFBlipAdditionalFiltersPrefix, filterName]];
        [galleryObjects addObject:object];
    }
    _filterGallery = [[AFBlipGalleryViewController alloc] initWithGalleryObjects:galleryObjects frame:CGRectMake((self.view.frame.size.width - kAFBlipAdditionalFiltersGallerySizeWidth)/2, kAFBlipAdditionalFiltersGalleryPosY, kAFBlipAdditionalFiltersGallerySizeWidth, kAFBlipAdditionalFiltersGallerySizeHeight)];
    [self addChildViewController:_filterGallery];
    [_contentScrollView addSubview:_filterGallery.view];
}

- (void)createDescriptionWithText:(NSString *)text {
    _filterDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - kAFBlipAdditionalFiltersGallerySizeWidth)/2, CGRectGetMaxY(_filterGallery.view.frame) + kAFBlipAdditionalFiltersDescriptionYOffset, kAFBlipAdditionalFiltersGallerySizeWidth, 0)];
    
    _filterDescriptionLabel.text = text;
    _filterDescriptionLabel.numberOfLines = 0;
    _filterDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    _filterDescriptionLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:0];
    _filterDescriptionLabel.textColor = [UIColor whiteColor];
    [_filterDescriptionLabel sizeToFit];
    [_contentScrollView addSubview:_filterDescriptionLabel];
}

- (void)createBuyButtonWithPrice:(CGFloat)price title:(NSString *)title {
    CGFloat submitButtonY = CGRectGetMaxY(_filterDescriptionLabel.frame) + kAFBlipAdditionalFiltersDescriptionYOffset;
    
    //Button
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(kAFBlipAdditionalFilters_SubmitButtonPaddingX, submitButtonY, CGRectGetWidth(self.view.bounds) - (kAFBlipAdditionalFilters_SubmitButtonPaddingX * 2), kAFBlipAdditionalFilters_SubmitButtonHeight)];
    _submitButton.autoresizingMask       = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    //Title
    NSString *text = [NSString stringWithFormat:title, price];
    [_submitButton setTitle:text forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    //Actions
    //Normal
    [_submitButton addTarget:self action:@selector(onSubmitButtonNormal:) forControlEvents:UIControlEventTouchCancel];
    [_submitButton addTarget:self action:@selector(onSubmitButtonNormal:) forControlEvents:UIControlEventTouchDragExit];
    [_submitButton addTarget:self action:@selector(onSubmitButtonNormal:) forControlEvents:UIControlEventTouchDragOutside];
    [_submitButton addTarget:self action:@selector(onSubmitButtonNormal:) forControlEvents:UIControlEventTouchUpOutside];
    
    //Highlight
    [_submitButton addTarget:self action:@selector(onSubmitButtonHighlight:) forControlEvents:UIControlEventTouchDown];
    [_submitButton addTarget:self action:@selector(onSubmitButtonHighlight:) forControlEvents:UIControlEventTouchDragEnter];
    [_submitButton addTarget:self action:@selector(onSubmitButtonHighlight:) forControlEvents:UIControlEventTouchDragInside];
    
    //Select
    [_submitButton addTarget:self action:@selector(onBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //Border
    _submitButton.layer.cornerRadius = CGRectGetHeight(_submitButton.frame) * 0.5f;
    _submitButton.layer.borderWidth  = kAFBlipAdditionalFilters_SubmitButtonBorderWidth;
    _submitButton.layer.borderColor  = [UIColor colorWithWhite:1.0f alpha:kAFBlipAdditionalFilters_SubmitButtonWhiteAlpha].CGColor;
    [_contentScrollView addSubview:_submitButton];
    [_contentScrollView setContentSize:CGSizeMake(_contentScrollView.frame.size.width, CGRectGetMaxY(_submitButton.frame) + kAFBlipAdditionalFiltersDescriptionYOffset)];
}

- (void)onSubmitButtonNormal:(UIButton *)button {
    
    button.backgroundColor = [UIColor clearColor];
}

- (void)onSubmitButtonHighlight:(UIButton *)button {
    
    button.backgroundColor = [UIColor colorWithWhite:1.0f alpha:kAFBlipAdditionalFilters_SubmitButtonWhiteAlpha];
}

- (void)onBuyButton:(UIButton *)button {
    
    [self onSubmitButtonNormal:button];
    
    _activityIndicator.alpha = 1;
    [_activityIndicator startAnimating];
    typeof(self) __weak wself = self;
    [AFBlipStoreKitManager sharedInstance].listnerBlock = ^(BOOL success) {
        if (success) {
            [_submitButton setTitle:NSLocalizedString(@"AFBlipAdditionalFiltersRestoreButtonTitle", nil) forState:UIControlStateNormal];
            [_activityIndicator stopAnimating];
            _activityIndicator.alpha = 0;
            NSString *title = NSLocalizedString(@"AFBlipAdditionalFiltersTitle", nil);
            NSString *message = NSLocalizedString(@"AFBlipAdditionalFiltersMessage", nil);
            if (_restore) {
                title = NSLocalizedString(@"AFBlipAdditionalFiltersRestoringTitle", nil);
                message = NSLocalizedString(@"AFBlipAdditionalFiltersRestoringMessage", nil);
            }
            if (_complete) {
                _complete();
            }
            [wself createAlertViewWithTitle:title message:message];
            [wself dismissView];
        } else {
            [_activityIndicator stopAnimating];
            _activityIndicator.alpha = 0;
        }
    };
    if (_restore) {
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    } else {
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:_filterPackProduct];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

- (void)createAlertViewWithTitle:(NSString *)title message:(NSString *)message {
    AFBlipAlertView *alert = [[AFBlipAlertView alloc] initWithTitle:title message:message buttonTitles:@[NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil)]];
    [alert show];
}

- (void)createActivityIndicator {
    _activityIndicator = [[AFBlipActivityIndicator alloc] initWithStyle:AFBlipActivityIndicatorType_Small];
    _activityIndicator.center = self.view.center;
    [self.view addSubview:_activityIndicator];
}

#pragma mark Storekit Product Request Methods
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    request.delegate = nil;
    _filterPackProduct = response.products.firstObject;
    
    [self createContentView];
    [self createFilterGallery];
    [self createDescriptionWithText:[_filterPackProduct localizedDescription]];
    [self createActivityIndicator];
    NSString *title = NSLocalizedString(@"AFBlipAdditionalFiltersSubmitButtonTitle", nil);
    for (NSDictionary *reciept in [[NSUserDefaults standardUserDefaults] arrayForKey:@"blipsUserReceipts"]) {
        if ([reciept[@"receipt_product_id"] isEqualToString:_filterPackProduct.productIdentifier]) {
            title = NSLocalizedString(@"AFBlipAdditionalFiltersRestoreButtonTitle", nil);
            _restore = YES;
            break;
        }
    }
    [self createBuyButtonWithPrice:[[_filterPackProduct price] floatValue] title:title];
    if (_loaded) {
        _loaded(self);
    }
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize {
    _filterDescriptionLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:0];
    [_filterDescriptionLabel sizeToFit];
    _filterDescriptionLabel.frame = CGRectMake((self.view.frame.size.width - kAFBlipAdditionalFiltersGallerySizeWidth)/2, CGRectGetMaxY(_filterGallery.view.frame) + kAFBlipAdditionalFiltersDescriptionYOffset, kAFBlipAdditionalFiltersGallerySizeWidth, _filterDescriptionLabel.frame.size.height);
    CGFloat submitButtonY = CGRectGetMaxY(_filterDescriptionLabel.frame) + kAFBlipAdditionalFiltersDescriptionYOffset;
    _submitButton.frame = CGRectMake(_submitButton.frame.origin.x, submitButtonY, _submitButton.frame.size.width, _submitButton.frame.size.height);
}

- (void)dealloc {
    _complete = NULL;
    _loaded = NULL;
}

@end
