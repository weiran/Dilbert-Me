//
//  DilbertManager.m
//  Dilbert Me
//
//  Created by Weiran Zhang on 17/01/2015.
//  Copyright (c) 2015 Weiran Zhang. All rights reserved.
//

#import "DilbertManager.h"

#import "Comic.h"

#import <AppKit/AppKit.h>
#import <AFNetworking/AFNetworking.h>
#import <HTMLReader/HTMLReader.h>
#import <PromiseKit/Promise.h>
#import <PromiseKit-AFNetworking/AFNetworking+PromiseKit.h>
#import <YLMoment/YLMoment.h>

@implementation DilbertManager

- (PMKPromise *)getLatest {
    return [AFHTTPRequestOperation request:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dilbert.com/"]]]
    .then(^(id responseObject) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            HTMLDocument *document = [HTMLDocument documentWithString:html];
            
            // get date
            HTMLElement *todaysComicDateElement = [document firstNodeMatchingSelector:@"h3.comic-item-date span a date"];
            NSString *todaysComicDateString = [todaysComicDateElement textContent];
            NSDate *todaysComicDate = [[YLMoment momentWithDateAsString:todaysComicDateString] date];
            
            // get image
            HTMLElement *todaysComicImgElement = [document firstNodeMatchingSelector:@"img.img-comic"];
            NSString *todaysComicImageURL = [todaysComicImgElement attributes][@"src"];
            
            [AFHTTPRequestOperation request:[NSURLRequest requestWithURL:[NSURL URLWithString:todaysComicImageURL]]]
            .then(^(id responseObject) {
                NSImage *image = [[NSImage alloc] initWithData:responseObject];
                Comic *comic = [[Comic alloc] initWithDate:todaysComicDate image:image];
                fulfill(comic);
            })
            .catch(^(NSError *error){
                reject(error);
            });;
        }];
    })
    .catch(^(NSError *error){
        NSLog(@"error: %@", error.localizedDescription);
        NSLog(@"original operation: %@", error.userInfo[AFHTTPRequestOperationErrorKey]);
    });
}

@end
