//
//  AFBlipSearchBarView.m
//  Blips
//
//  Created by Andrew Apperley on 2014-03-26.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipSearchBarView.h"
#import "AFBlipMainViewControllerStatics.h"
#import "AFDynamicFontMediator.h"

@interface AFBlipSearchBarView() <AFDynamicFontMediatorDelegate> {
    AFDynamicFontMediator   *_dynamicFont;
}

@end

@implementation AFBlipSearchBarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (!_searchBar) {
            _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [self addSubview:_searchBar];
            _searchBar.searchBarStyle = UISearchBarStyleMinimal;
            _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
            _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
            _searchBar.spellCheckingType = UITextSpellCheckingTypeNo;
            [_searchBar setImage:[UIImage imageNamed:@"AFBlipSearchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
            [_searchBar setImage:[UIImage imageNamed:@"AFBlipSearchCloseIcon"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
            _searchBar.barTintColor = [UIColor clearColor];
            _searchBar.tintColor = [UIColor whiteColor];
            _searchBar.placeholder      = NSLocalizedString(@"AFBlipConnectionsConnectionsSearch", nil);
            [_searchBar setValue:[UIColor whiteColor] forKeyPath:@"_searchField.textColor"];
            [_searchBar setValue:[UIColor whiteColor] forKeyPath:@"_searchField._placeholderLabel.textColor"];
            for (UIView *view in [_searchBar.subviews.firstObject subviews]){
                if ([NSStringFromClass([view class]) isEqualToString:@"UISearchBarBackground"]) {
                    view.alpha = 0;
                } else if ([NSStringFromClass([view class]) isEqualToString:@"UISearchBarTextField"]) {
                    [(UITextField *)view setKeyboardAppearance:UIKeyboardAppearanceDark];
                    view.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.3f].CGColor;
                    view.layer.borderWidth = 1;
                    view.layer.cornerRadius = 10;
                }
            }
        }
        
        self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundWhiteAlpha];
        [self createDynamicFont];
    }
    return self;
}

#pragma mark - Dynamic font
- (void)createDynamicFont {
    
    _dynamicFont          = [[AFDynamicFontMediator alloc] init];
    _dynamicFont.delegate = self;
    [_dynamicFont updateFontSize];
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator {
    
    for(UITextField *textField in [[_searchBar.subviews firstObject] subviews]) {
        
        if([textField isKindOfClass:[UITextField class]]) {
            textField.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:-2];
            return;
        }
    }
}

- (void)dealloc {
    _searchBar.delegate = nil;
}

@end