//
//  IMessageDelegate.h
//  xmpp
//
//  Created by Estefania Guardado on 02/11/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMessageDelegate <NSObject>

- (NSArray *) getMessages;
- (void) sendMessageOfUser: (NSDictionary *) message;

@end
