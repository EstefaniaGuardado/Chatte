//
//  RosterViewController.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/1/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "AppDelegate.h"
#import "IMessage.h"

@interface RosterViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, ChatDelegate, IMessage>

@property (weak) NSMutableArray * onlineBuddies;
@property (weak) AppDelegate *appDelegate;

@end
