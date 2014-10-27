//
//  Filter.h
//  Yelper
//
//  Created by Larry Wei on 10/26/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filter : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *APISearchName;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSArray *APISearchValues;
@property (nonatomic, assign) NSInteger numSectionRows;
@end
