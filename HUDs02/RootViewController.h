//
//  RootViewController.h
//  HUDs02
//
//  Created by Conrado Andreu Capdevila on 7/25/12.
//  Copyright (c) 2012 Tewti Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
{
	@private
	
	//	HUD visuals
	
	//	Reference to root layer
	__weak CALayer *hudLayerRef;
	
	//	Shown/hidden
	BOOL isHUDVisible;
	
	//	HUD interaction
	__weak UITapGestureRecognizer *hudTapRecognizerRef;
	
	//	Keys - tap on those to switch view controllers
	NSMutableArray *keys;
	
	//	Renderings of those keys in the HUD
	NSMutableDictionary *renderings;
	
	
	
	//	Child view controllers
	
	__weak UIViewController *childOnTopRef;
	
	NSMutableArray *controllers;
}

//	Small view that switches the HUD on/off
@property (nonatomic, weak) IBOutlet UIView *hudActivationViewRef;

//	Content view for child view controllers
@property (nonatomic, weak) IBOutlet UIView *childContainerViewRef;

//	Singleton
+ (RootViewController *)sharedInstance;

@end
