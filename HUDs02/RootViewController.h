//
//  RootViewController.h
//  HUDs02
//
//  Created by Conrado Andreu Capdevila on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
{
	@private
	
	__weak CALayer *hudLayerRef;
	
	BOOL isHUDVisible;
}

@property (nonatomic, weak) IBOutlet UIView *hudActivationViewRef;
@property (nonatomic, weak) IBOutlet UIView *childContainerViewRef;

+ (RootViewController *)sharedInstance;

@end
