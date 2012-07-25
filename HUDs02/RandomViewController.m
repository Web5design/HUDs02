//
//  RandomViewController.m
//  HUDs02
//
//  Created by Conrado Andreu Capdevila on 7/25/12.
//  Copyright (c) 2012 Tewti Development. All rights reserved.
//

#import "RandomViewController.h"

#import "UIColor-Expanded.h"

#import "ContentKey.h"

@interface RandomViewController ()

@end

@implementation RandomViewController

@synthesize key;

- (id)initWithContentKey:(ContentKey *)ck
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
		key = ck;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Do any additional setup after loading the view from its nib.
	self.view.backgroundColor = key.color;	
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
