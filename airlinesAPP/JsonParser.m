//
//  JsonParser.m
//  instagramAPP
//
//  Created by Mobile Apps Company on 7/21/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "JsonParser.h"
#import "AirlineObject.h"
@implementation JsonParser
-(void)startParsingData:(NSData *)data
{
    
    NSMutableArray *resultObjects = [[NSMutableArray alloc]init];
    NSError *error;

    NSMutableArray *airlinesArray = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:NSJSONReadingAllowFragments error:&error];
    
        for (NSDictionary *currentAirline in airlinesArray)
        {
            AirlineObject *airline = [AirlineObject new];
            airline.code = [currentAirline objectForKey:@"code"];
            airline.logoURL = [currentAirline objectForKey:@"logoURL"];
            airline.name = [currentAirline objectForKey:@"name"];
            airline.phone = [currentAirline objectForKey:@"phone"];
            airline.site = [currentAirline objectForKey:@"site"];
            [resultObjects addObject:airline];
        }
    
        
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            
            if ([self.delegate respondsToSelector:@selector(ParseFinishedWithObjects:)])
            {
                [self.delegate performSelector:@selector(ParseFinishedWithObjects:) withObject:resultObjects];
            }
            else
            {
                NSLog(@"Parse Finished. No delegate method or self de-allocated.");
            }
        });
 }








@end
