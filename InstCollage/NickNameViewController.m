//
//  NickNameViewController.m
//  InstCollage
//
//  Created by iButs on 18.02.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import "NickNameViewController.h"
#import "ImagesListViewController.h"

@interface NickNameViewController ()
@property (strong, nonatomic) NSDictionary *usersID;
@property (strong, nonatomic) NSDictionary *userMedia;
@property (strong, nonatomic) NSURLSession *currentSession;
@property (strong, nonatomic) NSArray *userImagesURL;

@end

@implementation NickNameViewController
@synthesize nickNameField;
@synthesize picker;
@synthesize usersID;
@synthesize userImagesURL;
@synthesize downloadImagesButton;
@synthesize backGround;

-(NSURLSession *)currentSession{
    return [NSURLSession sharedSession];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    nickNameField.delegate = self;
    picker.hidden = YES;
    downloadImagesButton.hidden = YES;
    backGround.image = [UIImage imageNamed:@"BackGround"];

}

-(void)viewWillDisappear:(BOOL)animated{
    nickNameField.text = nil;
    usersID = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)searchUsersByNickname:(NSString*) nickname{
    
    NSString *search = @"https://api.instagram.com/v1/users/search?q=";
    NSString *userID = @"&client_id=c7cd46910427490cbad97409634b6f5b";
    NSMutableString *request = [[NSMutableString alloc]initWithFormat:@"%@%@%@",search,nickname,userID];
    NSLog(@"request is :%@", request);
    NSURLSessionDataTask *users = [self.currentSession dataTaskWithURL:[NSURL URLWithString:request] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.usersID = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", self.usersID);
    }];
    [users resume];
}

-(void)searchImagesByID:(NSString*)identificator{
    NSString *search = @"https://api.instagram.com/v1/users/";
    NSString *userID = @"/media/recent/?client_id=c7cd46910427490cbad97409634b6f5b";
    NSMutableString *request = [[NSMutableString alloc]initWithFormat:@"%@%@%@",search,identificator,userID];
    NSLog(@"request is:%@",request);
    NSURLSessionDataTask *media = [self.currentSession  dataTaskWithURL:[NSURL URLWithString:request]completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.userMedia = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", self.userMedia);
        [picker stopAnimating];
        picker.hidden = YES;
    }];
    [media resume];
}

- (IBAction)endOfTypingName:(id)sender {
    [nickNameField resignFirstResponder];
    [self searchUsersByNickname:nickNameField.text];
    [picker startAnimating];
    while (!usersID)
    picker.hidden = NO;
    [picker stopAnimating];
    downloadImagesButton.hidden = NO;

}

- (IBAction)getImages:(id)sender {
    NSDictionary *objct = [usersID valueForKey:@"data"];
    if (!objct){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Attention" message:@"Please, enter correct login name for continue work with app" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [av show];
    } else {
        NSString *ident = [[objct valueForKey:@"id"]objectAtIndex:0];
        [self searchImagesByID:ident];
        while (!self.userMedia);
        self.userImagesURL = [[[[self.userMedia valueForKey:@"data"]valueForKey:@"images"]valueForKey:@"low_resolution"]valueForKey:@"url"];
      // [self performSegueWithIdentifier:@"imagesList" sender:self];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UINavigationController *nc = (UINavigationController*)[segue destinationViewController];
    ImagesListViewController *vc = [nc topViewController];
    vc.imagesURL = self.userImagesURL;
}

@end
