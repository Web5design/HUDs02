//
//  Content.m
//  HUDs02
//
//  Created by Conrado Andreu Capdevila on 7/25/12.
//  Copyright (c) 2012 Tewti Development. All rights reserved.
//

#import "ContentKey.h"

#import "UIColor+Crayons.h"
#import "UIColor-Expanded.h"

#import "RandomViewController.h"

@implementation ContentKey

@synthesize uuid, color;

+ (ContentKey *)keyWithIdentifier:(NSString *)identifier
{
	return [[ContentKey alloc] initWithIdentifier:identifier];
}

- (id)initWithIdentifier:(NSString *)identifier
{
	if (self = [super init]) {
		//	Keep values
		uuid = identifier;
		
		//	Compute values
		color = [UIColor randomColor];
	}
	return self;
}

- (CALayer *)rendering
{
	//	Root layer
	CALayer *L0 = [CALayer layer];
	
	L0.frame = CGRectMake(0.0f,0.0f, 96.0f,96.0f);
	
	L0.backgroundColor = color.CGColor;
	
	L0.cornerRadius = 9.0f;
	L0.borderColor = [UIColor silver].CGColor;

	L0.contents = (id)[[UIImage imageNamed:@"key01.png"] CGImage];
	
	//	Text layer
	CATextLayer *tlayer = [CATextLayer layer];
	
	tlayer.alignmentMode = kCAAlignmentLeft;
	
	tlayer.anchorPoint = CGPointMake(0.000f, 0.000f);
	
	tlayer.frame = CGRectMake(0.0f,0.0f, 96.0f - 8.0f, 12.0f);
	
	tlayer.string = self.uuid;
	
	tlayer.fontSize = 10.0f;
	tlayer.foregroundColor = [UIColor lead].CGColor;
	
	[L0 addSublayer:tlayer];
	
	tlayer.position = CGPointMake(4.0f, 4.0f);

	return L0;
}

- (UIViewController<ContentKeyController> *)viewController
{
	if (contentViewController) { return contentViewController; } else {
		
		//	Create it on the first call
		contentViewController = [[RandomViewController alloc] initWithContentKey:self];
		
		return contentViewController;
	}
}

@end
