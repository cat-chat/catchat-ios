//
//  JDPCatPickerViewController.m
//  Cat Chat
//
//  Created by Joel Parsons on 05/05/2014.
//  Copyright (c) 2014 Joel Parsons. All rights reserved.
//

#import "JDPCatPickerViewController.h"
//view
#import "JDPStoryboardIdentifiers.h"
#import "JDPCatThumbnailCell.h"
//controller
#import "JDPSnapCatViewController.h"

@interface JDPCatPickerViewController ()
@property (nonatomic, strong) NSArray * catImages;

@end

@implementation JDPCatPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFQuery * query = [PFQuery queryWithClassName:@"CatImage"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            self.catImages = objects;
            [self.collectionView reloadData];
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:JDPChosenCatSegue]) {
        JDPSnapCatViewController * snapCatController = segue.destinationViewController;
        NSIndexPath * selectedIndexPath = [self.collectionView indexPathsForSelectedItems].firstObject;
        PFObject * selectedImage = self.catImages[selectedIndexPath.row];
        snapCatController.catImage = selectedImage;
    }
}

#pragma mark - UICollectionViewDatasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.catImages.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JDPCatThumbnailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:JDPCatCellIdentifier
                                                                           forIndexPath:indexPath];

    PFObject * catImage = self.catImages[indexPath.row];
    PFFile * file = catImage[@"thumbnail"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        JDPCatThumbnailCell * currentCell = (JDPCatThumbnailCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [UIView transitionWithView:currentCell.imageView
                          duration:0.2f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            currentCell.imageView.image = [UIImage imageWithData:data];
                        } completion:NULL];
    }];
    return cell;
}


@end
