//
//  DetailsViewController.h
//  airlinesAPP
//
//  Created by Mobile Apps Company on 7/22/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AirlineObject.h"

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLlb;
@property (strong, nonatomic) IBOutlet UILabel *phoneLbl;
@property (strong, nonatomic) IBOutlet UILabel *siteLbl;

@property (strong, nonatomic) AirlineObject *airline;


- (IBAction)doBackButton:(UIBarButtonItem *)sender;

- (IBAction)doFavoriteButton:(UIButton *)sender;
@end
