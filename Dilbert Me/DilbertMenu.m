//
//  DilbertMenu.m
//  Dilbert Me
//
//  Created by Weiran Zhang on 17/01/2015.
//  Copyright (c) 2015 Weiran Zhang. All rights reserved.
//

#import "DilbertMenu.h"

@interface DilbertMenu ()
@property (strong, nonatomic) NSStatusItem *statusItem;
@end

@implementation DilbertMenu

- (instancetype)init {
    self = [super init];
    if (self) {
        NSNib *menuNib = [[NSNib alloc] initWithNibNamed:@"DilbertMenu" bundle:nil];
        [menuNib instantiateWithOwner:self topLevelObjects:nil];

        self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        [self.statusItem setMenu:self.statusMenu];
        [self.statusItem setTitle:@"D"];
        [self.statusItem setHighlightMode:YES];
    }
    return self;
}
@end
