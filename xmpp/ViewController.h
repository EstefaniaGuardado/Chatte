//
//  ViewController.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 8/29/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DAOUserDefaults.h"

@interface ViewController : UIViewController

@property (weak) AppDelegate *appDelegate;
@property (strong) DAOUserDefaults *daoUserDefaults;

@property (weak, nonatomic) IBOutlet UITextField *logTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;

- (IBAction)login:(id)sender;

@end

