//
//  AFBlipProfileCollectionView.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-08.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipProfileCollectionView.h"
#import "AFBlipProfileCollectionViewCell.h"

typedef NS_ENUM(NSUInteger, AFBlipProfileCollectionViewMenuItem) {
    
    AFBlipProfileCollectionViewMenuItem_EditProfile,
    AFBlipProfileCollectionViewMenuItem_Help,
    AFBlipProfileCollectionViewMenuItem_Feedback,
    AFBlipProfileCollectionViewMenuItem_Logout,
    AFBlipProfileCollectionViewMenuItem_Count
};

NSString *const AFBlipProfileCollectionView_CellReuseIdentifier = @"AFBlipProfileCollectionViewCellReuseIdentifier";

@interface AFBlipProfileCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation AFBlipProfileCollectionView

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame collectionViewLayout:[AFBlipProfileCollectionView collectionViewLayout]];
    if(self) {
        
        self.dataSource      = self;
        self.delegate        = self;
        self.backgroundColor = [UIColor clearColor];
        
        [self registerClass:[AFBlipProfileCollectionViewCell class] forCellWithReuseIdentifier:AFBlipProfileCollectionView_CellReuseIdentifier];
    }
    return self;
}
    
#pragma mark - UICollectionViewLayout
+ (UICollectionViewFlowLayout *)collectionViewLayout {
    
    //Layout
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.minimumInteritemSpacing = 0;
    collectionViewLayout.minimumLineSpacing      = 0;
    
    return collectionViewLayout;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return AFBlipProfileCollectionViewMenuItem_Count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //Cell
    AFBlipProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AFBlipProfileCollectionView_CellReuseIdentifier forIndexPath:indexPath];
    
    UIImage  *image;
    NSString *title;
    
    switch(indexPath.row) {
        case AFBlipProfileCollectionViewMenuItem_EditProfile:
            title = NSLocalizedString(@"AFBlipSettingsMenuEditProfile", nil);
            image = [UIImage imageNamed:@"AFBlipSettingsEditProfileIcon"];
            break;
        case AFBlipProfileCollectionViewMenuItem_Logout:
            title = NSLocalizedString(@"AFBlipSettingsMenuLogout", nil);
            image = [UIImage imageNamed:@"AFBlipSettingsLogoutIcon"];
            break;
        case AFBlipProfileCollectionViewMenuItem_Help:
            title = NSLocalizedString(@"AFBlipSettingsMenuHelp", nil);
            image = [UIImage imageNamed:@"AFBlipSettingsFAQIcon"];
            break;
        case AFBlipProfileCollectionViewMenuItem_Feedback:
            title = NSLocalizedString(@"AFBlipSettingsMenuFeedback", nil);
            image = [UIImage imageNamed:@"AFBlipSettingsFeedbackIcon"];
            break;
    }
    
    [cell updateImage:image title:title];

    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch(indexPath.row) {
        case AFBlipProfileCollectionViewMenuItem_EditProfile:
            if([_profileCollectionViewDelegate respondsToSelector:@selector(profileCollectionViewDidSelectEditProfile:)]) {
                [_profileCollectionViewDelegate profileCollectionViewDidSelectEditProfile:self];
            }
            break;
        case AFBlipProfileCollectionViewMenuItem_Logout:
            if([_profileCollectionViewDelegate respondsToSelector:@selector(profileCollectionViewDidSelectLogout:)]) {
                [_profileCollectionViewDelegate profileCollectionViewDidSelectLogout:self];
            }
            break;
        case AFBlipProfileCollectionViewMenuItem_Help:
            if([_profileCollectionViewDelegate respondsToSelector:@selector(profileCollectionViewDidSelectHelp:)]) {
                [_profileCollectionViewDelegate profileCollectionViewDidSelectHelp:self];
            }
            break;
        case AFBlipProfileCollectionViewMenuItem_Feedback:
            if([_profileCollectionViewDelegate respondsToSelector:@selector(profileCollectionViewDidSelectFeedback:)]) {
                [_profileCollectionViewDelegate profileCollectionViewDidSelectFeedback:self];
            }
            break;
            
        default:
            break;
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //Cell size
    CGFloat cellWidth = (CGRectGetWidth(self.frame) * 0.5f);
    
    return CGSizeMake(cellWidth, cellWidth);
}


#pragma mark - Dealloc
- (void)dealloc {
    _profileCollectionViewDelegate = nil;
}

@end