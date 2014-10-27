//
//  YelpTableViewCell.h
//  Yelper
//
//  Created by Larry Wei on 10/22/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessObject.h"

@interface YelpTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *businessImage;
@property (weak, nonatomic) IBOutlet UIImageView *businessRatingImage;
@property (weak, nonatomic) IBOutlet UILabel *businessName;
@property (weak, nonatomic) IBOutlet UILabel *businessDistance;
@property (weak, nonatomic) IBOutlet UILabel *businessAddress;
@property (weak, nonatomic) IBOutlet UILabel *businessReviewCount;
@property (weak, nonatomic) IBOutlet UIImageView *businessRating;
@property (weak, nonatomic) IBOutlet UILabel *businessCategories;

@property (strong, nonatomic) BusinessObject *b;



-(void) populateCell:(BusinessObject *) business;
@end
