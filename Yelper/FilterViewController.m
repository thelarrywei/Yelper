//
//  FilterViewController.m
//  Yelper
//
//  Created by Larry Wei on 10/26/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "FilterViewController.h"
#import "Filter.h"
#import "FilterSwitchCell.h"

@interface FilterViewController ()

@property(nonatomic, strong) NSDictionary *filters;
@property(nonatomic, strong) NSMutableArray *filterObjects;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSDictionary * tableViewSections;



@end

@implementation FilterViewController

Filter *category;
Filter *sort;
Filter *radius;
Filter *deals;




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //set up table sections
    category = [[Filter alloc] init];
    category.name = @"Category";
    category.APISearchName = @"category_filter";
    category.options = @[@"Arts and Entertainment", @"Restaurants", @"Grocery", @"Delivery"];
    category.APISearchValues = @[@"arts", @"restaurants", @"grocery", @"fooddeliveryservices"];
    category.numSectionRows = 4;
    
    sort = [[Filter alloc] init];
    sort.name = @"Sort";
    sort.APISearchName = @"sort";
    sort.options = @[@"Best Match", @"Distance", @"Rating"];
    sort.APISearchValues = @[@"0", @"1", @"2"];
    sort.numSectionRows = 3;
    
    radius = [[Filter alloc] init];
    radius.name = @"Distance";
    radius.APISearchName = @"radius_filter";
    radius.options = @[@"0.5 mi", @"1 mi", @"5 mi"];
    radius.APISearchValues = @[@"800", @"1600", @"8000"];
    radius.numSectionRows = 3;
    
    deals = [[Filter alloc] init];
    deals.name = @"Options";
    deals.APISearchName = @"deals_filter";
    deals.options = @[@"Offering a Deal"];
    deals.APISearchValues = @[@"true"];
    deals.numSectionRows = 1;
    
    self.filterObjects = [[NSMutableArray alloc] initWithObjects: category, sort, radius, deals, nil];
    //NSLog(@"Filter Ojects: %@", self.filterObjects);
    
    self.filters = @{category.APISearchName: [NSMutableSet set],
                     sort.APISearchName: [NSMutableSet set],
                     radius.APISearchName: [NSMutableSet set],
                     deals.APISearchName: [NSMutableSet set]
                     };
    
    NSLog(@"Filters: %@", self.filters);
                     
    //register nib
    [self.tableView registerNib: [UINib nibWithNibName:@"FilterSwitchCell" bundle:nil]forCellReuseIdentifier:@"FilterSwitchCell"];
    
    
    
    //self.tableViewSections = @{[@"Category":categories, @"Sort":sort, @"Distance Radius":radius, @"Deals":deals]};
    
    
    //configure the navigation bar
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.Title = @"Filters";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    
    //create a cancel and apply button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(onCancelButton)];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(onApplyButton)];
    
}

//set up table

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Filter *s = self.filterObjects[section];
    return s.name;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.filterObjects.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Filter *s = self.filterObjects[section];
    return s.numSectionRows;
}



-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FilterSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterSwitchCell"];
    cell.delegate = self;
    
    Filter *f = self.filterObjects[indexPath.section];
    if (![f.name isEqualToString:@"Category"]) {
        //NSLog(@"CHECKING IF TOGGLE SHOULD BE ON");
        if([self.filters[f.APISearchName] containsObject:f.APISearchValues[indexPath.row]]){
            [cell.optionSwitch setOn:YES animated:YES];
        }
        else {
            [cell.optionSwitch setOn:NO animated:NO];
        }
    }
    cell.optionLabel.text = f.options[indexPath.row];
    
    
    
    return cell;
}



//switch cell delegate
-(void) FilterSwitchCell:(FilterSwitchCell *)cell valueDidChange:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Filter *f = self.filterObjects[indexPath.section];
    if (value) {
        if ([f.name isEqualToString:@"Category"]) {
            [self.filters[f.APISearchName] addObject:f.APISearchValues[indexPath.row]];
            NSLog(@"Current Categories in filter are: %@", self.filters[f.APISearchName]);
            
        }
        else {
            [self.filters[f.APISearchName] removeAllObjects];
            [self.filters[f.APISearchName] addObject:f.APISearchValues[indexPath.row]];
            [self.tableView reloadData];
            NSLog(@"Current Categories in filter are: %@", self.filters[f.APISearchName]);
            
        }
        
        
        //NSLog(@"Selected IndexPath Section: %ld", indexPath.section);
        //NSLog(@"IndexPath Row: %ld", indexPath.row);
    }
    else {
        if ([f.name isEqualToString:@"Category"]) {
            [self.filters[f.APISearchName] removeObject:f.APISearchValues[indexPath.row]];
            NSLog(@"Current Categories in filter are: %@", self.filters[f.APISearchName]);
        }
        else {
            [self.filters[f.APISearchName] removeAllObjects];
            NSLog(@"Current Categories in filter are: %@", self.filters[f.APISearchName]);
        }
        
        //NSLog(@"Deselected IndexPath Section: %ld", indexPath.section);
        //NSLog(@"IndexPath Row: %ld", indexPath.row);
    }
}

-(void) onCancelButton {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void) onApplyButton {
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
