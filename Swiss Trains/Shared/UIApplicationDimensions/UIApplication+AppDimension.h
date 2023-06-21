//
//  UIApplication+AppDimension.h
//  NoteIt iOS
//
//  Created by Alain on 02.09.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (AppDimension)
+(CGSize) currentSize;
+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation;
+(CGSize) currentScreenSize;
@end
