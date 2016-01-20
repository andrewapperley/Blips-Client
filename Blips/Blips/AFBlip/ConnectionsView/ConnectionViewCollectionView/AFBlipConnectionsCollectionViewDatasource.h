//
//  AFBlipConnectionsCollectionViewDatasource.h
//  Blips
//
//  Created by Andrew Apperley on 2014-03-18.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

typedef void(^AFBlipConnectionsDatasourceCompletion)();

@interface AFBlipConnectionsCollectionViewDatasource : NSObject<UICollectionViewDataSource>

@property(nonatomic, copy, readonly)NSArray* connections;
@property(nonatomic, copy, readonly)NSArray* pendingRequests;
@property(nonatomic, copy, readonly)NSArray* personalSections;
@property(nonatomic, copy, readonly)NSArray* searchResults;

- (void)retrieveConnections:(AFBlipConnectionsDatasourceCompletion)completion;
- (void)updateConnectionsListAfterSearchingWithCompletion:(AFBlipConnectionsDatasourceCompletion)completion;
- (void)searchWithSearchQuery:(NSString *)searchQuery withCompletion:(AFBlipConnectionsDatasourceCompletion)completion;

@end