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
#define HEADER_INIT_FRAME CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT)
#define CELL_HEIGHT 45.0f

@interface ViewController () <UITableViewDelegate,UITableViewDataSource,HeaderViewDelegate>
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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 0.f, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview: _tableView];
    
    // Create the sticky header view
    [self createHeaderView];
}


#pragma mark - Header View
- (void)createHeaderView
{
    _headerView = [[HeaderView alloc]initWithFrame:HEADER_INIT_FRAME];
    _headerView.delegate = self;
    [_tableView setTableHeaderView:_headerView];
}

#pragma mark - Header View Delegate Method
- (void)toggleHeaderViewFrame
{
    [UIView animateWithDuration:0.8
                     animations:^{
                         
                         _headerView.isExpanded = !_headerView.isExpanded;
                         [_headerView updateFrame:_headerView.isExpanded ? [self.view frame] : HEADER_INIT_FRAME];

                     } completion:^(BOOL finished){
                     
                         [_tableView setScrollEnabled:!_headerView.isExpanded];
                         
                     }];

}

#pragma mark - ScrollView Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float delta = 0.0f;
    CGRect rect = HEADER_INIT_FRAME;
    
    // Only allow the header to stretch if pulled down
    if (_tableView.contentOffset.y < 0.0f)
    {
        // Scroll down
        delta = fabs(MIN(0.0f, _tableView.contentOffset.y));
    }

    rect.origin.y -= delta;
    rect.size.height += delta;

    [_headerView updateFrame:rect];

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
    return 12;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifier%i",indexPath.row];
    
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        if (indexPath.row == 0)
        {
            UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5f)];
            [lineTop setBackgroundColor:[UIColor blackColor]];
            [cell addSubview:lineTop];
        }
        
        UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT - 0.5f, self.view.frame.size.width, 0.5f)];
        [lineBottom setBackgroundColor:[UIColor blackColor]];
        [cell addSubview:lineBottom];
        
        [cell.textLabel setText:[NSString stringWithFormat:@"Cell %i",indexPath.row+1]];
    }
    
    
    
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

