//
//  Header.h
//  xmpp
//
//  Created by Estefania Guardado on 21/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IUserDatasource <NSObject>

@optional

- (void) updateInformation: (NSDictionary*) user;
- (NSDictionary *) getInformationUser;

@end
