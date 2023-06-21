//
//  UIBarButtonItem+DT.h
//  iCatalog
//
//  Created by Oliver Drobnik on 7/18/10.
//  Copyright 2010 Drobnik.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIBarButtonItem (DT)

+ (UIBarButtonItem *)flexibleSpace;
+ (UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width;

@end
