//
//  AirlineObject.h
//  airlinesAPP
//
//  Created by Mobile Apps Company on 7/22/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AirlineObject : NSObject

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *logoURL;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *imgLogo;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *site;
@property (nonatomic, assign) BOOL isFavorite;

@end
