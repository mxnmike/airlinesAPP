//
//  JsonParser.h
//  instagramAPP
//
//  Created by Mobile Apps Company on 7/21/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JsonParserDelegate <NSObject>

@required

-(void)ParseFinishedWithObjects:(NSMutableArray*)parsedObjects;
-(void)ParseFailedWithError:(NSError*)parseError;

@end

@interface JsonParser : NSObject

@property(weak,nonatomic) id<JsonParserDelegate>delegate;

-(void)startParsingData:(NSData*)data;
@end
