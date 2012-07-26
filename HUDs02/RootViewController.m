//
//  RootViewController.m
//  HUDs02
//
//  Created by Conrado Andreu Capdevila on 7/25/12.
//  Copyright (c) 2012 Tewti Development. All rights reserved.
//

#import "RootViewController.h"

#import "UIColor+Crayons.h"

#import "ContentKey.h"

@interface RootViewController ()

@end

static RootViewController *singletonInstance;

@implementation RootViewController

//	Singleton pattern
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
		
		controllers = [NSMutableArray array];
		
		keys = [NSMutableArray array];
		
		renderings = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)showHUD
{
	//	Move the root layer and its contents on screen
	[CATransaction begin];
	[CATransaction setAnimationDuration:1.0f];
	[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
	
	hudLayerRef.position = CGPointMake(20.0f,0.0f);
	
	[CATransaction commit];
	
	isHUDVisible = YES;
	
	//	Switch interaction
	self.childContainerViewRef.userInteractionEnabled = NO;
	
	hudTapRecognizerRef.enabled = YES;
}

- (void)hideHUD
{
	//	Move the root layer out of the way
	[CATransaction begin];
	[CATransaction setAnimationDuration:1.0f];
	[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
	
	hudLayerRef.position = CGPointMake(-1.0f * hudLayerRef.bounds.size.width, 0.0f);
	
	[CATransaction commit];
	
	isHUDVisible = NO;		
	
	//	Switch interaction
	self.childContainerViewRef.userInteractionEnabled = YES;
	
	hudTapRecognizerRef.enabled = NO;	
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

- (void)handleTapInHUD:(UITapGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateEnded)
	{
		//	Hit-test HUD layers
		
		CGPoint where = [recognizer locationInView:self.view];
		
		where = [self.view.layer convertPoint:where toLayer:self.view.layer.superlayer];
		
		CALayer *who = [self.view.layer.presentationLayer hitTest:where];
		
		if (who) {
			//	"Buttons" in the hud have this key
			id kv = [who valueForKey:@"ContentKey"];
			
			if (kv) {
				//	Do something with this
				ContentKey *ck = (ContentKey *)kv;
				
				//	For instance, display the associated view controller
				[self activateControllerForContentKey:ck];
			} else {
				
				//	Not a key, hide the HUD
				[self hideHUD];
			}
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
	
	//	HUD Taps
	UITapGestureRecognizer *R2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapInHUD:)];
	
	//	HUD is initially hidden
	R2.enabled = NO;
	
	[self.view addGestureRecognizer:R2];
	
	//	Keep a ref to that one
	hudTapRecognizerRef = R2;
	
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (! hudLayerRef) {
		//	Setup visuals for HUD
		CALayer *L1 = [CALayer layer];
		
		//	HUD will cover the container view area
		L1.frame = self.childContainerViewRef.bounds;
		
		L1.backgroundColor = [UIColor whiteColor].CGColor;
		
		L1.opacity = 0.250f;
		//	Ref is top-left corner
		L1.anchorPoint = CGPointMake(0.0f,0.0f);
		
		//	Out of the screen
		L1.position = CGPointMake(-1.0f * self.view.bounds.size.width, 0.0f);
		
		[self.view.layer addSublayer:L1];
		
		//	Keep a ref to it
		hudLayerRef = L1;
		
		//	Initial keys
		[self attachKeyToHUD:[ContentKey keyWithIdentifier:@"A01"]];
		[self attachKeyToHUD:[ContentKey keyWithIdentifier:@"A02"]];
		[self attachKeyToHUD:[ContentKey keyWithIdentifier:@"A03"]];
		[self attachKeyToHUD:[ContentKey keyWithIdentifier:@"A04"]];
		[self attachKeyToHUD:[ContentKey keyWithIdentifier:@"A05"]];		
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

#pragma mark - View Controllers Management

//	Select one child view controller as the active one
- (void)selectActiveViewController:(UIViewController *)vc animated:(BOOL)animated
{
	//	Container doesn't have a view
	if (![self isViewLoaded])
	{
		childOnTopRef = vc;
	}
	else if (childOnTopRef != vc)
	{
		//	If it's not currently on top
		UIViewController *fromViewController = childOnTopRef;
		UIViewController *toViewController = vc;
		
		//	If target is nil, just remove the one on top
		if (toViewController == nil)
		{
			[fromViewController.view removeFromSuperview];
			
			childOnTopRef = nil;
		}
		else if (fromViewController == nil)
		{
			//	If there's no top view controller
			
			//	Give target's view size and get it into the container view
			toViewController.view.frame = childContainerViewRef.bounds;
			
			[childContainerViewRef addSubview:toViewController.view];
			
			childOnTopRef = vc;
		}
		else if (animated)
		{
			//	Currently an empty animation
			CGRect rect = childContainerViewRef.bounds;
			
			toViewController.view.frame = rect;
			fromViewController.view.frame = rect;
			
			[self transitionFromViewController:fromViewController
							  toViewController:toViewController
									  duration:0.3
									   options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionTransitionCrossDissolve |UIViewAnimationOptionCurveEaseOut
									animations:^{}
									completion:^(BOOL finished) {
										//	Finishes with a new selected one
										childOnTopRef = toViewController;
									}];
		}
		else
		{
			//	Without animation
			[fromViewController.view removeFromSuperview];
			
			toViewController.view.frame = childContainerViewRef.bounds;
			[childContainerViewRef addSubview:toViewController.view];
			
			childOnTopRef = toViewController;
		}
	}
}

- (void)dismissWithAnimation:(BOOL)animated
{
	if (! [self isViewLoaded]) {
		
		UIViewController *fromVc = childOnTopRef;
		
		if (fromVc) {
			//	Out of array of controllers
			[controllers removeObject:fromVc];
			//	Out of the hierarchy
			[fromVc willMoveToParentViewController:nil];
			[fromVc removeFromParentViewController];
		}
		
		//	Select a new one
		if ([controllers count] > 0) {
			childOnTopRef = [controllers objectAtIndex:0];
		} else {
			childOnTopRef = nil;
		}
	} else {
		
		UIViewController *fromVc = childOnTopRef;
		UIViewController *toVc = nil;
		
		//	Pick one to move to
		if ([controllers count] > 1) {
			if ([controllers indexOfObject:fromVc] > 0) {
				toVc = [controllers objectAtIndex:([controllers indexOfObject:fromVc] - 1)];
			} else {
				toVc = [controllers objectAtIndex:0];
			}
		}
		
		//	Switch to that one
		[self selectActiveViewController:toVc animated:animated];
		
		//	Remove previous one
		[controllers removeObject:fromVc];
		[fromVc willMoveToParentViewController:nil];
		[fromVc removeFromParentViewController];
	}
}

//	Removes a view controller that's not on top
- (void)dismissBackgroundViewController:(UIViewController *)vc
{
	[controllers removeObject:vc];
	
	[vc willMoveToParentViewController:nil];
	[vc removeFromParentViewController];
}

- (void)insertViewController:(UIViewController *)vc
{
	if (! [controllers containsObject:vc]) {
		
		[controllers addObject:vc];
		
		//	Not there, insert it into VC hierarchy
		[self addChildViewController:vc];
		
		[vc willMoveToParentViewController:self];
		
		//	Make it selected VC
		[self selectActiveViewController:vc animated:YES];
	}
}

#pragma mark - HUD keys

- (CGPoint)positionForKeyInHUD:(ContentKey *)ck
{
	//	Index in array of keys
	NSUInteger n = [keys indexOfObject:ck];

	//	Turn index into coordinates; say a matrix of 3 x 3 elements
	
	return CGPointMake(32.0f + (96.0f + 4.0f) * (n % 3), 32.0f + (96.0f + 4.0f) * (n / 3));
}

- (void)attachKeyToHUD:(ContentKey *)ck
{
	if (! [keys containsObject:ck]) {
		//	Add new key
		[keys addObject:ck];

		//	Add visuals for the key
		CALayer *L0 = [ck rendering];
	
		L0.anchorPoint = CGPointMake(0.0f,0.0f);
		L0.position = [self positionForKeyInHUD:ck];
	
		//	Add hit-testing overlay
		CALayer *Ln = [CALayer layer];
		
		Ln.frame = CGRectMake(0.0f,0.0f, 96.0f,96.0f);
		Ln.opacity = 0.050f;
		
		[Ln setValue:ck forKey:@"ContentKey"];
		
		[L0 addSublayer:Ln];
		
		//	Into HUD layer
		[hudLayerRef addSublayer:L0];
	
		[renderings setValue:L0 forKey:ck.uuid];
	}
}

- (void)detachContextFromHUD:(ContentKey *)ck
{
	if ([keys containsObject:ck]) {
		//	Remove key
		[keys removeObject:ck];
	
		CALayer *rck = [renderings objectForKey:ck.uuid];
	
		[rck removeAllAnimations];
		[rck removeFromSuperlayer];
	}
}	

- (void)activateControllerForContentKey:(ContentKey *)ck
{
	//	Insert the view controller if it's not already there
	[self insertViewController:[ck viewController]];
	
	//	Select it
	[self selectActiveViewController:[ck viewController] animated:YES];
}

@end