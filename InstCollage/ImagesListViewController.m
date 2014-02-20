//
//  ImagesListViewController.m
//  InstCollage
//
//  Created by iButs on 18.02.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import "ImagesListViewController.h"
#import "CollageViewController.h"

@interface ImagesListViewController ()
@property (strong, nonatomic) NSURLSession *session;
@property (strong, atomic) NSMutableArray *images;
@end

@implementation ImagesListViewController
@synthesize imagesURL;
@synthesize session;
@synthesize images;

-(NSURLSession *)session{
    return [NSURLSession sharedSession];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Attention!" message:@"For correct work choose number of images like 9, 12, 15 & 18" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    self.tableView.allowsMultipleSelection = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self getAllImages];
        [av show];
        [self.tableView reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backToNickName:(id)sender {
       [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return imagesURL.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imageView.frame = CGRectMake(0, 0, 612, 612);
    [cell.imageView setImage:[images objectAtIndex:indexPath.row]];
    return cell;
}

-(void)getAllImages{
    images = [[NSMutableArray alloc]init];
    for (NSString *url in imagesURL){
        NSURL *crrnturl = [NSURL URLWithString:url];
        NSData *data = [NSData dataWithContentsOfURL:crrnturl];
        UIImage *image = [UIImage imageWithData:data];
        [images addObject:image];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSMutableArray *results = [[NSMutableArray alloc]init];
    CollageViewController *vc = [segue destinationViewController];
    NSArray *paths = [self.tableView indexPathsForSelectedRows];
    NSLog(@"Pathes is %@", paths);
    for (NSIndexPath *path in paths)
        [results addObject:[images objectAtIndex:path.row]];
    NSLog(@"selected cells is:%@",results);
    vc.imagesArray = [NSArray arrayWithArray:results];
}
@end
