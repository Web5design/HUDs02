//
//  RootViewController.m
//  HUDs02
//
//  Created by Conrado Andreu Capdevila on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

#import "UIColor+Crayons.h"

@interface RootViewController ()

@end

static RootViewController *singletonInstance;

@implementation RootViewController

+ (RootViewController *)sharedInstance
{
	if (! singletonInstance) {
		
		singletonInstance = [[RootViewController alloc] init];
	}
	
	return singletonInstance;
}

@synthesize hudActivationViewRef, childContainerViewRef;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		isHUDVisible = false;
    }
    return self;
}

- (void)showHUD
{
	[CATransaction begin];
	[CATransaction setAnimationDuration:1.0f];
	[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
	
	hudLayerRef.position = CGPointMake(20.0f,0.0f);
	
	[CATransaction commit];
	
	isHUDVisible = YES;		
}

- (void)hideHUD
{
	[CATransaction begin];
	[CATransaction setAnimationDuration:1.0f];
	[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
	
	hudLayerRef.position = CGPointMake(-1.0f * hudLayerRef.bounds.size.width, 0.0f);
	
	[CATransaction commit];
	
	isHUDVisible = NO;		
}

- (void)handleHUDRequest:(UITapGestureRecognizer *)recognizer
{
	//	Will show/hide the HUD
	if (recognizer.state == UIGestureRecognizerStateEnded)
	{			
		if (isHUDVisible) {
			
			[self hideHUD];
		} else {
			
			[self showHUD];
		}
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	//	HUD Activation/deactivation
	UITapGestureRecognizer *R1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHUDRequest:)];
	
	[self.hudActivationViewRef addGestureRecognizer:R1];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (! hudLayerRef) {
		//	Setup visuals for HUD
		CALayer *L1 = [CALayer layer];
		
		//	HUD will cover the container view area
		L1.frame = self.childContainerViewRef.bounds;
		
		L1.backgroundColor = [UIColor tangerine].CGColor;
		L1.opacity = 0.400f;
		//	Ref is top-left corner
		L1.anchorPoint = CGPointMake(0.0f,0.0f);
		
		//	Out of the screen
		L1.position = CGPointMake(-1.0f * self.view.bounds.size.width, 0.0f);
		
		[self.view.layer addSublayer:L1];
		
		//	Keep a ref to it
		hudLayerRef = L1;
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
