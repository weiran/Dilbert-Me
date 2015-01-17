//
//  AppDelegate.m
//  Dilbert Me
//
//  Created by Weiran Zhang on 17/01/2015.
//  Copyright (c) 2015 Weiran Zhang. All rights reserved.
//

#import "AppDelegate.h"

#import "DilbertMenu.h"

@interface AppDelegate ()
@property (strong) DilbertMenu *menu;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.menu = [[DilbertMenu alloc] init];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
