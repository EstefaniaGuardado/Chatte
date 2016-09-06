//
//  IMessage.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/6/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@protocol IMessage <NSObject>

@optional

- (void) handler: (XMPPMessage *) message;

@end
