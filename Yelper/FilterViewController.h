//
//  FilterViewController.h
//  Yelper
//
//  Created by Larry Wei on 10/26/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterSwitchCell.h"

@class FilterViewController;
@protocol FilterViewControllerDelegate <NSObject>
-(void) filtersViewController:(FilterViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters;
@end

@interface FilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FilterSwitchCellDelegate>
@property (nonatomic, weak) id<FilterViewControllerDelegate> delegate;

@end
