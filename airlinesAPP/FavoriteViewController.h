//
//  FavoriteViewController.h
//  airlinesAPP
//
//  Created by Mobile Apps Company on 7/22/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *airlineTableView;

@end
