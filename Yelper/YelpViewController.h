//
//  YelpViewController.h
//  Yelper
//
//  Created by Larry Wei on 10/22/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterViewController.h"

@interface YelpViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate, FilterViewControllerDelegate>

@end
