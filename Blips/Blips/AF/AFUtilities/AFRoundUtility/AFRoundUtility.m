//
//  AFRoundUtility.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-04-12.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFRoundUtility.h"

CGFloat afCeil(CGFloat number){
    
#if CGFLOAT_IS_DOUBLE
    return ceil(number);
#else
    return ceilf(number);
#endif
    
}

CGFloat afFloor(CGFloat number){
    
#if CGFLOAT_IS_DOUBLE
    return floor(number);
#else
    return floorf(number);
#endif
    
}

CGFloat afRound(CGFloat number){
    
#if CGFLOAT_IS_DOUBLE
    return round(number);
#else
    return roundf(number);
#endif
    
}