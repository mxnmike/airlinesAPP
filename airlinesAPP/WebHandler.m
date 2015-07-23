//
//  WebHandler.m
//  instagramAPP
//
//  Created by Mobile Apps Company on 7/21/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "WebHandler.h"

@implementation WebHandler



-(void)startConnectionWithURL:(NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (error)
        {
            dispatch_async(dispatch_get_main_queue(), ^(void)
            {
                
                if ([self.delegate respondsToSelector:@selector(didFinishWithErrors:)])
                {
                    [self performSelector:@selector(didFinishWithErrors:) withObject:error];
                }
                else
                {
                    NSLog(@"WebHandler Failed. Delegate Not responding.");
                }
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^(void)
            {
                if ([self.delegate respondsToSelector:@selector(didFinishSuccesfullWithData:)])
                {
                    [self.delegate performSelector:@selector(didFinishSuccesfullWithData:) withObject:data];
                }
                else
                {
                    NSLog(@"WebHandler Succeded. Delegate Not Responding.");
                }
            });
        }
        
    }];
    [task resume];
    [session finishTasksAndInvalidate];
}

@end
