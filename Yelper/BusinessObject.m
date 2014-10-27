//
//  BusinessObject.m
//  Yelper
//
//  Created by Larry Wei on 10/25/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "BusinessObject.h"

@implementation BusinessObject

- (id)initWithDictionary:(NSDictionary*) dictionary {
    self = [super init];
    if (self) {
        NSLog (@"Dictionary: %@", dictionary);
        self.name = dictionary[@"name"];
        //NSLog(@"Creating object for restaurant: %@", self.name);
        self.imageURL = dictionary[@"image_url"];
        self.ratingImageURL = dictionary[@"rating_img_url"];
        self.reviewCount = dictionary[@"review_count"];
        NSString *neighborhood;
        if ([dictionary valueForKeyPath:@"location.neighborhoods"] == nil) {
            neighborhood = [dictionary valueForKeyPath:@"location.city"];
        }
        else {
            neighborhood = [dictionary valueForKeyPath:@"location.neighborhoods"][0];
        }
        self.address = [NSString stringWithFormat:@"%@, %@",
                        [dictionary valueForKeyPath:@"location.address"][0],
                        neighborhood];
        //NSLog(@"Address: %@", self.address);
        NSArray *categories = dictionary[@"categories"];
        //NSLog(@"Categories: %@", categories);
        NSMutableString *cat = [NSMutableString string];
        for (int i = 0; i < categories.count; i++) {
            [cat appendString:categories[i][0]];
            if (i < categories.count - 1) {
                [cat appendString:@", "];
            }
        }
        self.categories = cat;
        //NSLog(@"Categories appended: %@", cat);
        self.distance = [dictionary[@"distance"] floatValue] / 1600;
    }

    return self;
}

+ (NSArray *)businessesWithDictionaries: (NSArray *)dictionaries {
    NSMutableArray *businesses = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        BusinessObject *business = [[BusinessObject alloc] initWithDictionary:dictionary];
        [businesses addObject:business];
    }
    
    return businesses;
}
@end
