StickyHeaderView
================

Example of how to create a UITableView HeaderView which sticks to the top and stretches when you pull down. Kind of like the app Tinder does.

![alt text](http://imgur.com/CLqiksy.png "Tinder like sticky header view whick stretches when pulled down")

## Install

If you want to use the header view with the integrated scrollview like in the code simply copy `HeaderView.h` and `HeaderView.m` into your project and use it accordingly.

## Getting Started

Basically you set up a header view for your UITableView:

```objectivec
- (void)createHeaderView
{
    _headerView = [[HeaderView alloc]initWithFrame:HEADER_INIT_FRAME];
    _headerView.delegate = self;
    [_tableView setTableHeaderView:_headerView];
}
```

And then tell the header view to react accordingly depending on the table views content offset:

```objectivec
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
```

The header view can be tapped and will expand to full screen and vice versa.

This is really simple. Check out the code for more.
