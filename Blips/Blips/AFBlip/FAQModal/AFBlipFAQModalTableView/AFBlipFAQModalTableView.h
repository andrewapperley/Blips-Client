//
//  AFBlipFAQModalTableView.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-15.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFBlipFAQModalTableView;

@protocol AFBlipFAQModalTableViewDatasource <NSObject>

@required
- (NSArray *)questionTextArrayForFAQTable:(AFBlipFAQModalTableView *)FAQTable;
- (NSArray *)answerTextArrayForFAQTable:(AFBlipFAQModalTableView *)FAQTable;

@end

@interface AFBlipFAQModalTableView : UIView

@property (nonatomic, weak) id<AFBlipFAQModalTableViewDatasource> datasource;

@end