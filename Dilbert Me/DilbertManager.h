//
//  DilbertManager.h
//  Dilbert Me
//
//  Created by Weiran Zhang on 17/01/2015.
//  Copyright (c) 2015 Weiran Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@class Comic, PMKPromise;

@interface DilbertManager : NSObject <QLPreviewPanelDataSource, QLPreviewPanelDelegate>

@property (nonatomic, strong) NSArray *comics;

- (PMKPromise *)getLatest;

@end
