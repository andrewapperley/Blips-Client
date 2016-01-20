//
//  UIFont+AFBlipFont.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-04-07.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AFBlipFontType) {
    
    /** The system font type. */
    AFBlipFontType_None,
    
    /** Helvetica. */
    AFBlipFontType_Helvetica,
    
    /** Title font. */
    AFBlipFontType_Title,
    
    /** Navigation bar title font. */
    AFBlipFontType_NavBarTitle
};

@interface UIFont (AFBlipFont)

/** Returns a font from a font type and size offset. This font size is determined by the system font size + the given offset. Default font size is '14'. */
+ (UIFont *)fontWithType:(AFBlipFontType)fontType sizeOffset:(CGFloat)sizeOffset;

/** Returns a font from a font type and size offset. This font size is determined by the system font size + the given offset. Default font size is '14'. Max Size limits the dynamic font size. */
+ (UIFont *)fontWithType:(AFBlipFontType)fontType sizeOffset:(CGFloat)sizeOffset maxSize:(CGFloat)maxSize;


@end