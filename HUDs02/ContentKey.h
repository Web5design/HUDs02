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
	
	//	One view controller per key
	UIViewController<ContentKeyController> *contentViewController;
}

@property (nonatomic, strong, readonly) NSString *uuid;

@property (nonatomic, strong, readonly) UIColor *color;


+ (ContentKey *)keyWithIdentifier:(NSString *)identifier;

- (id)initWithIdentifier:(NSString *)identifier;

- (CALayer *)rendering;


- (UIViewController<ContentKeyController> *)viewController;

@end
