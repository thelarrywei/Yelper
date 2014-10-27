//
//  YelpTableViewCell.m
//  Yelper
//
//  Created by Larry Wei on 10/22/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "YelpTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation YelpTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.businessName.preferredMaxLayoutWidth = self.businessName.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    // Configure the view for the selected state
}

-(void) populateCell:(BusinessObject *)business {
    self.b = business;
    self.businessReviewCount.text = [NSString stringWithFormat:@"%@ Reviews", self.b.reviewCount];
    self.businessAddress.text = self.b.address;
    self.businessDistance.text = [NSString stringWithFormat:@"%0.1f mi", self.b.distance];
    self.businessCategories.text = self.b.categories;
    [self.businessImage setImageWithURL:[NSURL URLWithString:self.b.imageURL]];
    [self.businessRating setImageWithURL:[NSURL URLWithString:self.b.ratingImageURL]];
    
    
    self.businessImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.businessImage.layer.shadowOffset = CGSizeMake(2, 2);
    self.businessImage.layer.shadowOpacity = .99;
    self.businessImage.layer.shadowRadius = 3.0;
    
}

-(void) layoutSubviews {
    [super layoutSubviews];
    self.businessName.preferredMaxLayoutWidth = self.businessName.frame.size.width;
    
}
@end
