//
//  FilterSwitchCell.h
//  Yelper
//
//  Created by Larry Wei on 10/26/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterSwitchCell;

@protocol FilterSwitchCellDelegate <NSObject>

-(void) FilterSwitchCell:(FilterSwitchCell *) cell valueDidChange:(BOOL)value;

@end

@interface FilterSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (weak, nonatomic) IBOutlet UISwitch *optionSwitch;
@property (nonatomic, weak) id<FilterSwitchCellDelegate> delegate;
@property (nonatomic, assign) BOOL on;

-(void) setOn:(BOOL) on animated:(BOOL)animated;
@end
