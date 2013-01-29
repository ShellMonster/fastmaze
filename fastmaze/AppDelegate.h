//
//  AppDelegate.h
//  toddlermaze
//
//  Created by Jonny Brannum on 1/21/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic,retain) RootViewController	*viewController;

@end
