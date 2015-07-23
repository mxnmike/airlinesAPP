//
//  WebHandler.h
//  instagramAPP
//
//  Created by Mobile Apps Company on 7/21/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebHandlerDelegate <NSObject>

@required
-(void)didFinishSuccesfullWithData:(NSData*)data;
-(void)didFinishWithErrors:(NSError*) error;

@end


@interface WebHandler : NSObject

@property(weak,nonatomic) id<WebHandlerDelegate>delegate;

-(void)startConnectionWithURL:(NSURL*)url;


@end
