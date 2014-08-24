//
//  JDPInboxViewController.m
//  Cat Chat
//
//  Created by Joel Parsons on 05/05/2014.
//  Copyright (c) 2014 Joel Parsons. All rights reserved.
//

#import "JDPInboxViewController.h"
#import "JDPStoryboardIdentifiers.h"

@interface JDPInboxViewController ()
@property (nonatomic, strong) NSArray * messages;
@property (nonatomic, strong) NSDateFormatter * dateFormatter;
@end

@implementation JDPInboxViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.locale = [NSLocale currentLocale];
    self.dateFormatter.doesRelativeDateFormatting = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    PFQuery * query = [PFQuery queryWithClassName:@"Message"];
    [query orderByDescending:@"messageDate"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.messages = objects;
        [self.tableView reloadData];
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (! [PFUser currentUser]) {
        [self performSegueWithIdentifier:JDPSplashSegue
                                  sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.messages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:JDPMessageCell];

    PFObject * message = self.messages[indexPath.row];

    return cell;
}

#pragma mark - target action

-(IBAction)unwindToInbox:(UIStoryboardSegue *)sender{
    
}

- (IBAction)logoutButtonTapped:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:JDPSplashSegue
                              sender:nil];
}

@end
