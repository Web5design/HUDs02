//
//  ContentKeyController.h
//  HUDs02
//
//  Created by Conrado Andreu Capdevila on 7/25/12.
//  Copyright (c) 2012 Tewti Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ContentKey;

//	A UIViewController that is representing a content key
@protocol ContentKeyController <NSObject>

- (id)initWithContentKey:(ContentKey *)ck;

@end
