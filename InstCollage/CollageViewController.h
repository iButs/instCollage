//
//  CollageViewController.h
//  InstCollage
//
//  Created by iButs on 18.02.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface CollageViewController : UIViewController<MFMailComposeViewControllerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UIImageView *collageImage;
@property (strong, nonatomic) NSArray *imagesArray;
-(void)makeCollage:(NSArray *)images;
@end
