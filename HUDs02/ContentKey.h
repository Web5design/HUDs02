//
//  Content.h
//  HUDs02
//
//  Created by Conrado Andreu Capdevila on 7/25/12.
//  Copyright (c) 2012 Tewti Development. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ContentKeyController.h"

@interface ContentKey : NSObject
{
	@private
	
	//	One view controller per key; lazy creation
	UIViewController<ContentKeyController> *contentViewController;
}

//	To compare content keys
@property (nonatomic, strong, readonly) NSString *uuid;

//	Some data to init the controller
@property (nonatomic, strong, readonly) UIColor *color;


+ (ContentKey *)keyWithIdentifier:(NSString *)identifier;

- (id)initWithIdentifier:(NSString *)identifier;

//	Provide a rendering of this key for the HUD
- (CALayer *)rendering;

//	Create the view controller that will represent this content key
- (UIViewController<ContentKeyController> *)viewController;

@end
