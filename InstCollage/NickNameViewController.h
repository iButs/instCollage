//
//  NickNameViewController.h
//  InstCollage
//
//  Created by iButs on 18.02.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NickNameViewController : UIViewController<UITextFieldDelegate, NSURLSessionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nickNameField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *picker;
@property (weak, nonatomic) IBOutlet UIButton *downloadImagesButton;
@property (weak, nonatomic) IBOutlet UIImageView *backGround;


@end
