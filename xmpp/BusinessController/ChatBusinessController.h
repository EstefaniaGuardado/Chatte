//
//  ChatBusinessController.h
//  xmpp
//
//  Created by Estefania Guardado on 02/11/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPBusinessController.h"
#import "IMessageDelegate.h"
#import "IChatRepresentationHandler.h"

@interface ChatBusinessController : NSObject <IMessageDelegate>

@property (weak) XMPPBusinessController * xmppBusinessController;

@property (strong, atomic) NSArray * messages;
@property (strong) NSString *jid;
@property (weak) id<IChatRepresentationHandler> handler;

@end
