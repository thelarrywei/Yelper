//
//  FilterSwitchCell.m
//  Yelper
//
//  Created by Larry Wei on 10/26/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "FilterSwitchCell.h"

@interface FilterSwitchCell ()


- (IBAction)switchValueChanged:(id)sender;


@end

@implementation FilterSwitchCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) setOn:(BOOL)on animated:(BOOL)animated {
        self.on = on;
    [self.optionSwitch setOn:on animated:animated];
}

-(void) setOn:(BOOL)on {
    [self setOn:on animated:NO];
    
}


- (IBAction)switchValueChanged:(id)sender {
    NSLog(@"Cell state switched to: %@", self.optionSwitch.on? @"SWITCH ON" : @"SWITCH OFF");
    [self.delegate FilterSwitchCell:self valueDidChange:self.optionSwitch.on];
}
@end
