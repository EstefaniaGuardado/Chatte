//
//  Header.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/9/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@protocol IQuery <NSObject>

@optional

- (void) didReceiveIQ:(XMPPIQ *)iq;

@end
