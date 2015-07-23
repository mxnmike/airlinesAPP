//
//  DetailsViewController.m
//  airlinesAPP
//
//  Created by Mobile Apps Company on 7/22/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "DetailsViewController.h"
#import "Airline.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.nameLlb.text = self.airline.name;
    if ([_airline.phone isEqualToString:@""])
        self.phoneLbl.text = @"N/A";
    else
        self.phoneLbl.text = self.airline.phone;
    if ([_airline.site isEqualToString:@""])
    {
        self.siteLbl.text = @"N/A";
        [self.siteLbl setUserInteractionEnabled:NO];
    }
    else
    {
        self.siteLbl.text = self.airline.site;
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnLink:)];
        // if labelView is not set userInteractionEnabled, you must do so
        [self.siteLbl setUserInteractionEnabled:YES];
        [self.siteLbl addGestureRecognizer:gesture];
    }
    
    self.imgView.image = self.airline.imgLogo;
    
    if (_airline.isFavorite)
        [self.favoriteButton setImage:[UIImage imageNamed:@"FAV_ON"] forState:UIControlStateNormal];
    else
         [self.favoriteButton setImage:[UIImage imageNamed:@"FAV_OFF"] forState:UIControlStateNormal];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doBackButton:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doFavoriteButton:(UIButton *)sender
{
    if (!self.airline.isFavorite)
    {
        self.airline.isFavorite = YES;
        [self.favoriteButton setImage:[UIImage imageNamed:@"FAV_ON"] forState:UIControlStateNormal];
        NSManagedObjectContext *context = [self managedObjectContext];

        // Create a new Entity
        NSEntityDescription *airline = [NSEntityDescription insertNewObjectForEntityForName:@"Airline" inManagedObjectContext:context];

        NSData *imageData = UIImageJPEGRepresentation(self.airline.imgLogo, 0.0);
        [airline setValue:self.airline.name forKey:@"name"];
        [airline setValue:self.airline.code forKey:@"code"];
        [airline setValue:self.airline.logoURL forKey:@"url"];
        [airline setValue:imageData forKey:@"img"];
        [airline setValue:self.airline.phone forKey:@"phone"];
        [airline setValue:self.airline.site forKey:@"site"];
        [airline setValue:[NSNumber numberWithBool:self.airline.isFavorite] forKey:@"favorite"];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
    }
    else
    {
        NSLog(@"Remove Favorite");
        NSManagedObjectContext *context = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Airline" inManagedObjectContext:context]];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"code == %@ ",self.airline.code]];
        
        NSError* error = nil;
        NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
        
        if (results.count > 0)
        {
            [context deleteObject:[results objectAtIndex:0]];
            NSError *error = nil;
            if ([context save:&error] == NO) {
                NSAssert(NO, @"Save should not fail\n%@", [error localizedDescription]);
                abort();
            }
            else
            {
                [self.favoriteButton setImage:[UIImage imageNamed:@"FAV_OFF"] forState:UIControlStateNormal];
                self.airline.isFavorite = NO;
            }

        }

        
        
        
        

    }
}



-(void)userTappedOnLink:(UIGestureRecognizer *)gesture
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.airline.site]]];

}

@end
