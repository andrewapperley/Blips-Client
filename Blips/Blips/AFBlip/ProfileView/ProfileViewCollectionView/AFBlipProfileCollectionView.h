//
//  AFBlipProfileCollectionView.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-08.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFBlipProfileCollectionView;

@protocol AFBlipProfileCollectionViewDelegate <NSObject>

@optional
- (void)profileCollectionViewDidSelectEditProfile:(AFBlipProfileCollectionView *)profileCollectionView;
- (void)profileCollectionViewDidSelectLogout:(AFBlipProfileCollectionView *)profileCollectionView;
- (void)profileCollectionViewDidSelectHelp:(AFBlipProfileCollectionView *)profileCollectionView;
- (void)profileCollectionViewDidSelectFeedback:(AFBlipProfileCollectionView *)profileCollectionView;

@end

@interface AFBlipProfileCollectionView : UICollectionView

@property (nonatomic, weak) id<AFBlipProfileCollectionViewDelegate> profileCollectionViewDelegate;

@end