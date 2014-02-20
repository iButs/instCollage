//
//  CollageViewController.m
//  InstCollage
//
//  Created by iButs on 18.02.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import "CollageViewController.h"

@interface CollageViewController ()


@end

@implementation CollageViewController
@synthesize emailField;
@synthesize collageImage;
@synthesize imagesArray;


- (void)viewDidLoad{
    [super viewDidLoad];
    [self makeCollage:imagesArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)makeCollage:(NSArray *)images{
    int height = 0;
    int width = 0;

    for (UIImage *image in images) {
        height+=image.size.height;
        width+=image.size.width;
    }
    CGSize newSize = CGSizeMake(width/3, height/2);
    collageImage.frame=CGRectMake(0, 0, newSize.width, newSize.height);
    UIGraphicsBeginImageContext(newSize);
    
    int xCoor=0, yCoor = 0;
    
    for (UIImage *image in images){
        
        if (xCoor>=newSize.width){
            yCoor+=image.size.height;
            xCoor = 0;
        }
        [image drawInRect:CGRectMake(xCoor,yCoor,image.size.width,image.size.height)blendMode:kCGBlendModeNormal alpha:0.8];
        xCoor+=image.size.width;
    }
    self.collageImage.image = UIGraphicsGetImageFromCurrentImageContext();
    NSLog(@"image is:%@",UIGraphicsGetImageFromCurrentImageContext());
}

#pragma mark - mailController

- (IBAction)toSendOnMail:(id)sender {
   if ([MFMailComposeViewController canSendMail]){UIAlertView *err = [[UIAlertView alloc]initWithTitle:@"Sending error" message:@"Please, login for your mail account at first" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [err show];
   } else {
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
    
    [mailComposeViewController setSubject:@"Collage"];
    NSData *imageData = UIImagePNGRepresentation(collageImage.image);
    [mailComposeViewController addAttachmentData:imageData mimeType:@"image/png" fileName:@"photo"];
    NSString *emailBody = @"Look at my collage!";
    [mailComposeViewController setMessageBody:emailBody isHTML:NO];

    NSArray *alicilar=[[NSArray alloc]initWithObjects:emailField.text, nil];
    [mailComposeViewController setToRecipients:alicilar];
    [self presentViewController:mailComposeViewController animated:YES completion:NULL];

   }
}

- (IBAction)typingEnd:(id)sender {
    [emailField resignFirstResponder];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)endWriting:(id)sender {

}


@end
