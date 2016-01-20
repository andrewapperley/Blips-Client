//
//  AFBlipConnectionsViewControllerStatics.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-17.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - View controller
/** The width of the connections view controller. */
extern const CGFloat kAFBlipConnectionsViewControllerStatics_ConnectionsViewWidth;

/** The x position of the connections view controller when closed. */
extern const CGFloat kAFBlipConnectionsViewControllerStatics_ConnectionsViewClosedPosX;

/** The x position of the connections view controller when open. */
extern const CGFloat kAFBlipConnectionsViewControllerStatics_ConnectionsViewOpenPosX;

/** The y position of the connections view collection view. */
extern const CGFloat kAFBlipConnectionsViewControllerStatics_CollectionViewYOffset;

/** The collection view cell key. */
extern NSString* const kAFBlipConnectionsViewControllerStatics_CollectionViewCellKey;

/** Section 0 collection view cell key */
extern NSString* const kAFBlipConnectionsViewControllerStatics_CollectionViewCellSection0Key;

/** Header Collection view cell key*/
extern NSString* const kAFBlipConnectionsViewControllerStatics_CollectionViewCellHeaderKey;

/** Search Collection view cell key*/
extern NSString* const kAFBlipConnectionsViewControllerStatics_CollectionViewCellSearchKey;

/** Spacing for Connection list personal cell content - Profile Width*/
extern const CGFloat kAFBlipConnectionPersonalProfileWidth;
/** Spacing for Connection list cell content - Profile Y Offset*/
extern const CGFloat kAFBlipConnectionPersonalProfileYOffset;
/** Spacing for Connection list cell content - Profile X Offset*/
extern const CGFloat kAFBlipConnectionPersonalProfileXOffset;
/** Spacing for Connection list cell content - Profile Width*/
extern const CGFloat kAFBlipConnectionUserProfileWidth;
/** Spacing for Connection list cell content - Profile Y Offset*/
extern const CGFloat kAFBlipConnectionUserProfileYOffset;
/** Spacing for Connection list cell content - Profile X Offset*/
extern const CGFloat kAFBlipConnectionUserProfileXOffset;
/** Spacing for Connection list cell content - Profile Name Size (Width & Height)*/
extern const CGFloat kAFBlipConnectionUserProfileNameSizeOffset;
/** Spacing for Connection list cell content - Header Name Size (Width & Height)*/
extern const CGFloat kAFBlipConnectionHeaderNameSizeOffset;

/** Connections List Personal Sections */
typedef NS_ENUM(NSInteger, kAFBlipConnectionsPersonalSection) {
    kAFBlipConnectionsPersonalSection_Recent,
    kAFBlipConnectionsPersonalSection_Favourites
};

/** Connections List Collectionview Sections */
typedef NS_ENUM(NSInteger, kAFBlipConnectionsListSections) {
    kAFBlipConnectionsListSections_PersonalSection,
    kAFBlipConnectionsListSections_PendingRequestsSection,
    kAFBlipConnectionsListSections_ConnectionsSection,
    kAFBlipConnectionsListSections_SearchSection,
    kAFBlipConnectionsListSections_Count
};