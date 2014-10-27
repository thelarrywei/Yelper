//
//  BusinessObject.h
//  Yelper
//
//  Created by Larry Wei on 10/25/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UiKit.h>

@interface BusinessObject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *ratingImageURL;
@property (nonatomic, strong) NSString *reviewCount;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic, assign) CGFloat distance;

+ (NSArray *)businessesWithDictionaries: (NSArray *)dictionaries;

@end
