//
//  ViewController.m
//  StickyHeaderView
//
//  Created by Bastian Kohlbauer on 15.03.14.
//  Copyright (c) 2014 Bastian Kohlbauer. All rights reserved.
//

#import "ViewController.h"
#import "HeaderView.h"

#define HEADER_HEIGHT 200.0f
#define CELL_HEIGHT 45.0f

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) HeaderView *headerView;
@end

@implementation ViewController

#pragma mark - Load View
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set views background color
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // Set up the table view
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview: _tableView];
    
    // Create the sticky header
    [self createHeaderView];
}


#pragma mark - Header View
- (void)createHeaderView
{
    _headerView = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT)];
    _tableView.tableHeaderView = _headerView;
    
}

#pragma mark - ScrollView Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect rect = _headerView.frame;
    
    // Only allow the header to stretch if pulled down
    if (_tableView.contentOffset.y <= 0.0f)
    {
        float delta = fabs(MIN(0, _tableView.contentOffset.y));
        
        rect.origin.y = - delta;
        rect.size.height = HEADER_HEIGHT + delta;
        _headerView.frame = rect;
        _headerView.scrollView.frame = rect;
    }
    else
    {
        rect.origin.y = 0;
        rect.size.height = HEADER_HEIGHT;
        _headerView.frame = rect;
        _headerView.scrollView.frame = rect;
    }
    
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        if (indexPath.row == 0)
        {
            UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5f)];
            [lineTop setBackgroundColor:[UIColor blackColor]];
            [cell addSubview:lineTop];
        }
        
        UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT - 0.5f, self.view.frame.size.width, 0.5f)];
        [lineBottom setBackgroundColor:[UIColor blackColor]];
        [cell addSubview:lineBottom];
        
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"Cell %i",indexPath.row+1]];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

