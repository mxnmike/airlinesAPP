//
//  ViewController.h
//  airlinesAPP
//
//  Created by Mobile Apps Company on 7/21/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebHandler.h"
#import "JsonParser.h"
@interface AirlinesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,WebHandlerDelegate,JsonParserDelegate>

@property (strong, nonatomic) IBOutlet UITableView *airlineTableView;


@end

