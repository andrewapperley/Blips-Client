//
//  UIFont+AFBlipFont.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-04-07.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "UIFont+AFBlipFont.h"

#pragma mark - Constants 
NSString *const kUIFontAFBlipFont_Helvetica   = @"HelveticaNeue-Light";
NSString *const kUIFontAFBlipFont_Title       = @"Noteworthy-Light";
NSString *const kUIFontAFBlipFont_NavBarTitle = @"GillSans-Light";

@implementation UIFont (AFBlipFont)

+ (UIFont *)fontWithType:(AFBlipFontType)fontType sizeOffset:(CGFloat)sizeOffset maxSize:(CGFloat)maxSize {
    
    UIFont *returnFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    CGFloat fontSize = MIN(returnFont.pointSize + sizeOffset - 2, maxSize);
    
    switch(fontType) {
        case AFBlipFontType_Helvetica:
            returnFont = [UIFont fontWithName:kUIFontAFBlipFont_Helvetica size:fontSize];
            break;
        case AFBlipFontType_Title:
            returnFont = [UIFont fontWithName:kUIFontAFBlipFont_Title size:fontSize];
            break;
        case AFBlipFontType_NavBarTitle:
            returnFont = [UIFont fontWithName:kUIFontAFBlipFont_NavBarTitle size:fontSize];
            break;
        case AFBlipFontType_None:
        default:
            returnFont = [UIFont systemFontOfSize:fontSize];
            break;
    }
    
    return returnFont;
}

+ (UIFont *)fontWithType:(AFBlipFontType)fontType sizeOffset:(CGFloat)sizeOffset {
    
    UIFont *returnFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    CGFloat fontSize = returnFont.pointSize + sizeOffset - 2;
    
    switch(fontType) {
        case AFBlipFontType_Helvetica:
            returnFont = [UIFont fontWithName:kUIFontAFBlipFont_Helvetica size:fontSize];
            break;
        case AFBlipFontType_Title:
            returnFont = [UIFont fontWithName:kUIFontAFBlipFont_Title size:fontSize];
            break;
        case AFBlipFontType_NavBarTitle:
            returnFont = [UIFont fontWithName:kUIFontAFBlipFont_NavBarTitle size:fontSize];
            break;
        case AFBlipFontType_None:
        default:
            returnFont = [UIFont systemFontOfSize:fontSize];
            break;
    }
    
    return returnFont;
}

@end