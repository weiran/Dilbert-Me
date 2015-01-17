Modern development is highly asynchronous: isn’t it about time iOS developers had tools that made programming asynchronously powerful, easy and delightful?

**Vastly, copiously, vigorously documented at [promisekit.org](http://promisekit.org).**

![PromiseKit](http://promisekit.org/public/img/tight-header.png)

```objc
UIActionSheet *sheet = …;
sheet.message = @"Share photo with your new local bestie?";
sheet.promise.then(^(NSNumber *dismissedButtonIndex){
    if (dismissedButtonIndex.intValue == alert.cancelButtonIndex)
        return;

    UIImagePickerController *picker = …;
    [self promiseViewController:picker animated:YES completion: nil].then(^(UIImage *img, NSData *imgData){

        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        return [CLLocationManager promise].then(^(CLLocation *located){
            return [NSURLConnection GET:@"share.com/token/%f/%f", located.latitude, located.longitude];
        }).finally(^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }).then(^(NSDictionary *json){
            // the JSON is automatically decoded

            MFMessageViewController *messagevc = …;
            messagevc.to = json[@"to_email"];
            messagevc.body = json[@"message_text"];
            [messagevc addAttachmentData:imgData typeIdentifier:(NSString *)kUTTypeJPEG filename:@"image.jpeg"];
            
            return [self promiseViewController:messagevc animated:YES completion:nil];
        });
        
    }).catch(^(NSError *error){
        // because we returned promises in the above handler, any errors
        // that may occur during execution of the chain will be caught here
        [[UIAlertView:error] show];
    });
});
```

* PromiseKit can and should be integrated into the other Pods you use.
* PromiseKit is complete, well-tested and in apps on the store.

For guides and complete documentation visit [promisekit.org](http://promisekit.org).


#Swift

The Swift version of PromiseKit takes advantage of many new Swift features to make using PromiseKit even more delightful.

To use the Swift version clone the project and drop the `xcodeproj` into your project. Once CocoaPods properly supports Swift frameworks, we will update the podspec accordingly.

```swift
let sheet = UIAlertView(…)
sheet.message = "Share photo with your new local bestie?"
sheet.promise().then { dismissedButtonIndex in
    if dismissedButtonIndex == alert.cancelButtonIndex
        return

    let picker = UIImagePickerController(…)
    promiseViewController(picker).then { (img, imgData) in

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        return CLLocationManager.promise().then { located in
            return NSURLConnection.GET("share.com/token/\(located.latitude)/\(located.longitude)")
        }.finally {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }.then { (json: NSDictionary) in
            let messagevc = MFMessageViewController(…)
            messagevc.to = json["to_email"]
            messagevc.body = json["message_text"]
            messagevc.addAttachmentData(imgData, typeIdentifier:kUTTypeJPEG, filename:"image.jpeg")
            return promiseViewController(messagevc)
        }
        
    }.catch { error in
        // because we returned promises in the above handler, any errors
        // that may occur during execution of the chain will be caught here
        UIAlertView(error).show()
    })
})
```

Sadly Swift promises cannot be used from Objective-C, but Objective-C promises can be used from Swift. Though if you do use Objective-C promises, be aware that they are tricky to use in Swift due to the unusual way PromiseKit uses Objective-C.


#Donations

PromiseKit is almost completely the work of one man: me; [Max Howell](https://mxcl.github.io). I thoroughly enjoyed making PromiseKit, but nevertheless if you have found it useful then your bitcoin will give me a warm fuzzy feeling from my head right down to my toes: 1JDbV5zuym3jFw4kBCc5Z758maUD8e4dKR.
