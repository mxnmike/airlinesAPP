//
//  FavoriteViewController.m
//  airlinesAPP
//
//  Created by Mobile Apps Company on 7/22/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "FavoriteViewController.h"
#import "AirlineObject.h"
#import "AirlineTableViewCell.h"
#import "DetailsViewController.h"
#import <CoreData/CoreData.h>

@interface FavoriteViewController ()
{
    NSMutableArray *airlinesFavoriteArray;
    NSMutableArray *arrayOfObjects;
}
@end

@implementation FavoriteViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    airlinesFavoriteArray = [NSMutableArray new];
    arrayOfObjects = [NSMutableArray new];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.airlineTableView deselectRowAtIndexPath:[self.airlineTableView indexPathForSelectedRow] animated:animated];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Airline"];
    airlinesFavoriteArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.airlineTableView reloadData];

    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
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
    return airlinesFavoriteArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AirlineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    AirlineObject *anAirline = [AirlineObject new];
    
    NSManagedObject *airline = [airlinesFavoriteArray objectAtIndex:indexPath.row];
    UIImage *img = [UIImage imageWithData:[airline valueForKey:@"img"]];
    anAirline.imgLogo = img;
    anAirline.code = [airline valueForKey:@"code"];
    anAirline.name = [airline valueForKey:@"name"];
    anAirline.logoURL = [airline valueForKey:@"url"];
    anAirline.phone = [airline valueForKey:@"phone"];
    anAirline.site = [airline valueForKey:@"site"];
    anAirline.isFavorite = [[airline valueForKey:@"favorite"] boolValue];
    
    
    cell.nameLbl.text = anAirline.name;
    
    [arrayOfObjects addObject:anAirline];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:[airlinesFavoriteArray objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove device from table view
        [airlinesFavoriteArray removeObjectAtIndex:indexPath.row];
        [self.airlineTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    DetailsViewController *detailVC = (DetailsViewController*)[segue destinationViewController];
    //[[segue destinationViewController] setDelegate:self];
    detailVC.airline = arrayOfObjects[[self.airlineTableView.indexPathForSelectedRow row]];
}



#pragma mark - Coredata Methods

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


@end
