//
//  ViewController.m
//  airlinesAPP
//
//  Created by Mobile Apps Company on 7/21/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "AirlinesViewController.h"
#import "AirlineObject.h"
#import "AirlineTableViewCell.h"
#import "DetailsViewController.h"
#define AIRLINEURL @"https://www.kayak.com/h/mobileapis/directory/airlines"
@interface AirlinesViewController ()

@end
NSArray *arrayOfAirlines;
@implementation AirlinesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    arrayOfAirlines = [NSArray new];
    NSURL *url = [NSURL URLWithString:AIRLINEURL];
    WebHandler *wh = [WebHandler new];
    [wh setDelegate:self];

    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    [wh startConnectionWithURL:url];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.airlineTableView deselectRowAtIndexPath:[self.airlineTableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayOfAirlines.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AirlineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    AirlineObject *anAirline = [arrayOfAirlines objectAtIndex:indexPath.row];
    
    
    cell.nameLbl.text = anAirline.name;
    
    
    cell.imgView.alpha = 0.0;
    
    if (anAirline.imgLogo)
    {
        cell.imgView.image = anAirline.imgLogo;
        cell.imgView.alpha = 1.0f;
    }
    else
    {
        cell.imgView.image = [UIImage imageNamed:@""];
        dispatch_queue_t myQueue = dispatch_queue_create("myQueue", nil);
        dispatch_async(myQueue, ^(void){
            [anAirline setImgLogo:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kayak.com%@",anAirline.logoURL]]]]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [cell.imgView setImage:anAirline.imgLogo];
                [UIView animateWithDuration:0.25 animations:^{
                    cell.imgView.alpha = 1.0f;
                }];
                
            });
        });

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    DetailsViewController *detailVC = (DetailsViewController*)[segue destinationViewController];
    //[[segue destinationViewController] setDelegate:self];
    detailVC.airline = arrayOfAirlines[[self.airlineTableView.indexPathForSelectedRow row]];

}



#pragma mark - WebHandlerDelegate
-(void)didFinishSuccesfullWithData:(NSData *)data
{
    JsonParser *parse = [JsonParser new];
    [parse setDelegate:self];
    [parse startParsingData:data];
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
}

-(void)didFinishWithErrors:(NSError *)error
{
    
}



#pragma mark - JsonParser Delegate

-(void)ParseFinishedWithObjects:(NSMutableArray *)parsedObjects
{
    arrayOfAirlines = [arrayOfAirlines arrayByAddingObjectsFromArray:[parsedObjects copy]];
    [self.airlineTableView reloadData];
}

-(void)ParseFailedWithError:(NSError *)parseError
{
    
}


@end
