//
//  NSString+DT.h
//  ASiST
//
//  Created by Oliver on 15.06.09.
//  Copyright 2009 drobnik.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSString (DT)

// helper function
- (NSString *) getValueForNamedColumn:(NSString *)column_name  headerNames:(NSArray *)header_names;
- (NSDate *) dateFromString;
- (NSArray *) optionsFromSelect;
- (NSString *)stringByFindingFormPostURLwithName:(NSString *)formName;
- (NSArray *)arrayWithHrefDicts;
- (NSString *)hrefForLinkContainingText:(NSString *)searchText;
- (NSString *) stringByUrlEncoding;
- (NSString *) stringByUrlDecoding;

- (NSComparisonResult)compareDesc:(NSString *)aString;


// md5 maker
- (NSString * )md5;

// method to get the path for a file in the document directory
+ (NSString *) pathForFileInDocuments:(NSString *)fileName;

+ (NSString *)cachesPath;
+ (NSString *)documentsPath;


+ (NSString *) pathForLocalizedFileInAppBundle:(NSString *)fileName ofType:(NSString *)type;


- (NSString *)onlyFirstComponents:(NSInteger)number withSeparator:(NSString *)separator;

- (NSString *) stringBySubstitutingInfoTokens;


+ (NSString *)stringWithUUID;

- (NSString *)stringByDeletingNumberInBrackets;

@end
