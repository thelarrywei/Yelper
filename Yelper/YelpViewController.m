//
//  YelpViewController.m
//  Yelper
//
//  Created by Larry Wei on 10/22/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "YelpViewController.h"
#import "YelpClient.h"
#import "YelpTableViewCell.h"
#import "BusinessObject.h"
#import "FilterViewController.h"

NSString * const kYelpConsumerKey = @"Qph663H1ApPvee70FxlNfg";
NSString * const kYelpConsumerSecret = @"W2PHJwA_kVAY2QPdz3NFHCqjGG4";
NSString * const kYelpToken = @"uL-02r8EuA8VbFS0dAlAMYYywD1md2e8";
NSString * const kYelpTokenSecret = @"ydJ0x_UAKBS5UZTFkKLGW4BFpL0";

@interface YelpViewController ()
@property (nonatomic, strong) YelpClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *businesses;
@property (nonatomic, strong) NSString *geolocation;


@property (nonatomic, retain) UISearchBar *searchBar;


@property (nonatomic, retain) UIBarButtonItem *filterButton;
@property (nonatomic, strong) NSString *searchTerm;

@end

@implementation YelpViewController 


-(void) getGeocoding:(NSString *) location {
    self.geolocation = @"37.7749295, -122.4194155";
    NSString *searchTerm = [location stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&key=AIzaSyAaC6oxRuRY0gnmU-m3FHQl3nwLykj9ZR0", searchTerm]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue: [NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
        }
        else {
            NSDictionary *r = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"results"][0][@"geometry"][@"location"];
            NSDictionary *test = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"results"][0];
            self.geolocation = [NSString stringWithFormat:@"%@,%@", r[@"lat"], r[@"lng"]];
            NSLog(@"TEST: %@", test);
        }
        NSLog(@"geocode response %@",self.geolocation);
        [self initYelpClient];
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.businesses = [[NSMutableArray alloc]init];
    
    //configure the navigation bar
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //create a filter button
    self.filterButton =[[UIBarButtonItem alloc] initWithTitle:@"Filter " style:UIBarButtonItemStyleDone target:self action:@selector(onFilterButton)];
    
    
    
    // Do any additional setup after loading the view from its nib.
    NSString *location = @"San Francisco";
    [self getGeocoding:location];
    
    
    // add a search bar
    self.searchTerm = @"Sushi";
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;

    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.leftBarButtonItem = self.filterButton;
    
    
    //Set up the table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //set up filters view
    
    [self.tableView registerNib: [UINib nibWithNibName:@"YelpTableViewCell" bundle:nil]forCellReuseIdentifier:@"YelpTableViewCell"];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

//SEARCH BAR STUFF


-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float scrollViewHeight = scrollView.frame.size.height;
    NSLog(@"scrollViewHeight, %f", scrollViewHeight);
    float scrollContentSizeHeight = scrollView.contentSize.height;
    NSLog(@"scrollContentSizeHeight, %f", scrollContentSizeHeight);
    float scrollOffset = scrollView.contentOffset.y;
    NSLog(@"scrollOffset, %f", scrollContentSizeHeight);
    
    if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
    {
        NSLog(@"Reached to bottom");
        [self updateSearchTerm];
        
        [self.client searchWithTerm:self.searchTerm geo:self.geolocation offset:[NSString stringWithFormat: @"%ld", self.businesses.count] success:^(AFHTTPRequestOperation *operation, id response) {
            //get the response and load it into an array of Businesses
            //NSLog(@"response: %@", response);
            
            NSArray *businessDictionaries = response[@"businesses"];
            
            //NSLog(@"%@", businessDictionaries);
            NSArray *businesses = [BusinessObject businessesWithDictionaries:businessDictionaries];
            for (int i = 0; i < businesses.count; i++) {
                [self.businesses addObject:businesses[i]];
            }
            [self.tableView reloadData];
            NSLog(@"Number of Businesses: %ld", self.businesses.count);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];

        
    }
}
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO];
    NSLog(@"Beginning to Drag");
    [self updateSearchTerm];
}
-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"@HERE");
    [self.searchBar setShowsCancelButton:YES];
    self.searchBar.text = @"";
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    NSLog(@"SearchBarButtonClicked");
    [self.searchBar setShowsCancelButton:NO];
    self.searchTerm = self.searchBar.text;
    NSLog(@"New Search Term: %@", self.searchTerm);
    [self initYelpClient];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO];
    [self updateSearchTerm];
    NSLog(@"Search Bar Cancelled");
}

-(void) updateSearchTerm {
    self.searchBar.text = self.searchTerm;
}


-(void) initYelpClient {
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    
    NSMutableDictionary *searchTerms = [[NSMutableDictionary alloc] init];
    [searchTerms setObject:self.searchTerm forKey:@"term"];
    [searchTerms setObject:self.geolocation forKey:@"ll"];

    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    [self updateSearchTerm];
    
    [self.client searchWithFilters:searchTerms success:^(AFHTTPRequestOperation *operation, id response) {
        //get the response and load it into an array of Businesses
        //NSLog(@"response: %@", response);
        NSArray *businessDictionaries = response[@"businesses"];
        //NSLog(@"%@", businessDictionaries);
        self.businesses = [BusinessObject businessesWithDictionaries:businessDictionaries];
        [self.tableView reloadData];
        NSLog(@"Number of Businesses: %ld", self.businesses.count);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    
    

}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"Number of table cells populated %ld", self.businesses.count);
    return self.businesses.count;
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YelpTableViewCell"];
    BusinessObject *b = self.businesses[indexPath.row];
    
    //fill in cell
    [cell populateCell:b];
    cell.businessName.text = [NSString stringWithFormat:@"%ld. %@", indexPath.row + 1, b.name];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onFilterButton {
    FilterViewController *fvc = [[FilterViewController alloc] init];
    fvc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:fvc];
    [self presentViewController:nvc animated:YES completion:nil];
    
}

-(void) filtersViewController:(FilterViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    NSLog(@"filters are changing");
    NSLog(@"New Filters: %@", filters);
    
    NSMutableDictionary *searchTerms = [[NSMutableDictionary alloc] init];
    [searchTerms setObject:self.searchTerm forKey:@"term"];
    [searchTerms setObject:self.geolocation forKey:@"ll"];
    
    
    if ([[filters[@"category_filter"] allObjects] count] > 0) {
        NSLog(@"NUMBER OF CATEGORIES: %ld", [[filters[@"category_filter"] allObjects] count]);
        NSString *categories = [[filters[@"category_filter"] allObjects] componentsJoinedByString:@","];
        [searchTerms setObject:categories forKey:@"category_filter"];
    }
    if ([[filters[@"sort"] allObjects] count] > 0) {
        NSString *sort = [filters[@"sort"] allObjects][0];
        [searchTerms setObject:sort forKey:@"sort"];
    }
    if ([[filters[@"radius_filter"] allObjects] count] > 0) {
        NSString *radius_filter = [filters[@"radius_filter"] allObjects][0];
        [searchTerms setObject:radius_filter forKey:@"radius_filter"];
    }
    if ([[filters[@"deals_filter"] allObjects] count] > 0) {
        NSString *deals_filter = [filters[@"deals_filter"] allObjects][0];
        [searchTerms setObject:deals_filter forKey:@"deals_filter"];
    }
    
    NSLog(@"Search parameters: %@", searchTerms);
    [self.client searchWithFilters:searchTerms success:^(AFHTTPRequestOperation *operation, id response) {
        //get the response and load it into an array of Businesses
        //NSLog(@"response: %@", response);
        NSLog(@"***************CHECKPOINT 1");
        //NSLog(@"Response: %@", response);
        
            NSArray *businessDictionaries = response[@"businesses"];
            //NSLog(@"%@", businessDictionaries);
            self.businesses = [BusinessObject businessesWithDictionaries:businessDictionaries];
            NSLog(@"***************CHECKPOINT 2");
            [self.tableView reloadData];
            NSLog(@"Number of Businesses: %ld", self.businesses.count);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    
    [self.tableView reloadData];

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
