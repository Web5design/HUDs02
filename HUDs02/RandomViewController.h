//
//  RandomViewController.h
//  HUDs02
//
//  Created by Conrado Andreu Capdevila on 7/25/12.
//  Copyright (c) 2012 Tewti Development. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContentKeyController.h"

@interface RandomViewController : UIViewController<ContentKeyController>

@property (nonatomic, weak, readonly) ContentKey *key;

- (id)initWithContentKey:(ContentKey *)ck;

@end
