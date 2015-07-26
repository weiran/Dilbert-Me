/*
 The MIT License (MIT)
 
 Copyright (c) 2014 Christos Sotiriou
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import "AFNetworking+PromiseKit.h"
#import <PromiseKit/Promise+When.h>

<<<<<<< HEAD

const NSString *AFHTTPRequestOperationErrorKey =  @"afHTTPRequestOperationError";

=======
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
typedef enum {
	AF_OPERATION_POST,
	AF_OPERATION_GET,
	AF_OPERATION_PATCH,
	AF_OPERATION_DELETE,
	AF_OPERATION_HEAD,
	AF_OPERATION_PUT
} AF_OPERATION_KIND;

@implementation AFHTTPRequestOperation (Promises)

- (AFPromise *)promise
{
	return [self promiseByStartingImmediately:NO];
}

- (AFPromise *)promiseAndStartImmediately
{
	return [self promiseByStartingImmediately:YES];
}

- (AFPromise *)promiseByStartingImmediately:(BOOL)startImmediately
{
<<<<<<< HEAD
	return [AFPromise promiseWithResolverBlock:^(PMKResolver resolver){
		[self setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
			resolver(PMKManifold(responseObject, operation));
=======
	return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter){
		[self setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
			fulfiller(PMKManifold(responseObject, operation));
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			id info = error.userInfo.mutableCopy;
			info[AFHTTPRequestOperationErrorKey] = operation;
			id newerror = [NSError errorWithDomain:error.domain code:error.code userInfo:info];
<<<<<<< HEAD
			resolver(newerror);
=======
			rejecter(newerror);
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
		}];
		if (startImmediately) {
			[self start];
		}
	}];
}

<<<<<<< HEAD
+ (AFPromise *)request:(NSURLRequest *)request
=======
+ (PMKPromise *)request:(NSURLRequest *)request
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
	NSOperationQueue *q = [NSOperationQueue currentQueue] ? : [NSOperationQueue mainQueue];
	return [self request:request queue:q];
}

+ (AFPromise *)request:(NSURLRequest *)request queue:(NSOperationQueue *)queue
{
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[queue addOperation:operation];
	return [operation promise];
}

@end



@implementation AFHTTPRequestOperationManager (Promises)

- (AFPromise *)POST:(NSString *)URLString parameters:(id)parameters
{
	return [[self POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {} failure:^(AFHTTPRequestOperation *operation, NSError *error) {}] promise];
}

<<<<<<< HEAD
- (AFPromise *)POSTMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
=======
- (PMKPromise *)POSTMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
    return [self operationSequenceWithType:AF_OPERATION_POST urls:urlStringsArray parameters:parametersArray];
}


<<<<<<< HEAD
- (AFPromise *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
=======
- (PMKPromise *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
	return [[self POST:URLString parameters:parameters constructingBodyWithBlock:block success:nil failure:nil] promise];
}

- (AFPromise *)GET:(NSString *)URLString parameters:(id)parameters
{
	return [[self GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {} failure:^(AFHTTPRequestOperation *operation, NSError *error) {}] promise];
}

<<<<<<< HEAD
- (AFPromise *)GETMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
=======
- (PMKPromise *)GETMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
    return [self operationSequenceWithType:AF_OPERATION_GET urls:urlStringsArray parameters:parametersArray];
}

<<<<<<< HEAD
- (AFPromise *)PUT:(NSString *)URLString parameters:(id)parameters;
=======
- (PMKPromise *)PUT:(NSString *)URLString parameters:(id)parameters;
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
	return [[self PUT:URLString parameters:parameters success:nil failure:nil] promise];
}

<<<<<<< HEAD
- (AFPromise *)PUTMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
=======
- (PMKPromise *)PUTMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
    return [self operationSequenceWithType:AF_OPERATION_PUT urls:urlStringsArray parameters:parametersArray];
}

<<<<<<< HEAD
- (AFPromise *)DELETE:(NSString *)URLString parameters:(id)parameters
=======
- (PMKPromise *)DELETE:(NSString *)URLString parameters:(id)parameters
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
	return [[self DELETE:URLString parameters:parameters success:nil failure:nil] promise];
}

<<<<<<< HEAD
- (AFPromise *)DELETEMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
=======
- (PMKPromise *)DELETEMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
    return [self operationSequenceWithType:AF_OPERATION_DELETE urls:urlStringsArray parameters:parametersArray];
}


<<<<<<< HEAD
- (AFPromise *)PATCH:(NSString *)URLString parameters:(id)parameters
=======
- (PMKPromise *)PATCH:(NSString *)URLString parameters:(id)parameters
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
	return [[self PATCH:URLString parameters:parameters success:nil failure:nil] promise];
}

<<<<<<< HEAD
- (AFPromise *)PATCHMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
=======
- (PMKPromise *)PATCHMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
    return [self operationSequenceWithType:AF_OPERATION_PATCH urls:urlStringsArray parameters:parametersArray];
}


<<<<<<< HEAD
- (AFPromise *)HEAD:(NSString *)URLString parameters:(id)parameters
=======
- (PMKPromise *)HEAD:(NSString *)URLString parameters:(id)parameters
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
    return [[self HEAD:URLString parameters:parameters success:nil failure:nil] promise];
}

<<<<<<< HEAD
- (AFPromise *)HEADMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
=======
- (PMKPromise *)HEADMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
    return [self operationSequenceWithType:AF_OPERATION_HEAD urls:urlStringsArray parameters:parametersArray];
}


<<<<<<< HEAD
- (AFPromise *)operationSequenceWithType:(AF_OPERATION_KIND)operationKind urls:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
=======
- (PMKPromise *)operationSequenceWithType:(AF_OPERATION_KIND)operationKind urls:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
    assert (urlStringsArray.count == parametersArray.count);
    NSMutableArray *operations = [NSMutableArray array];

    for (int i=0; i<urlStringsArray.count; i++){
        NSString *urlString = urlStringsArray[i];
        NSDictionary *parameters = parametersArray[i];

<<<<<<< HEAD
        AFPromise *p = [self promiseForNetworkOperation:operationKind withURL:urlString andParameters:parameters];
=======
        PMKPromise *p = [self promiseForNetworkOperation:operationKind withURL:urlString andParameters:parameters];
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3

        [operations addObject:p.then(^(id responseObject, AFHTTPRequestOperation *operation){
            return [PMKPromise promiseWithValue:@{kPMKAFResponseObjectKey : responseObject, kPMKAFResponseOperationKey : operation}];
        })];
    }

<<<<<<< HEAD
	return PMKWhen(operations);
=======
    return [PMKPromise when:operations];
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
}



<<<<<<< HEAD
- (AFPromise *)promiseForNetworkOperation:(AF_OPERATION_KIND)operationKind withURL:(NSString *)urlString andParameters:(id)parameters
=======
- (PMKPromise *)promiseForNetworkOperation:(AF_OPERATION_KIND)operationKind withURL:(NSString *)urlString andParameters:(id)parameters
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
    switch (operationKind) {
        case AF_OPERATION_GET:
            return [self GET:urlString parameters:parameters];
        case AF_OPERATION_DELETE:
            return [self DELETE:urlString parameters:parameters];
        case AF_OPERATION_PATCH:
            return [self PATCH:urlString parameters:parameters];
        case AF_OPERATION_POST:
            return [self POST:urlString parameters:parameters];
        case AF_OPERATION_PUT:
            return [self PUT:urlString parameters:parameters];
        case AF_OPERATION_HEAD:
            return [self HEAD:urlString parameters:parameters];
        default:
            break;
    }
    return nil;
}

@end



@implementation AFHTTPSessionManager (Promises)

- (NSURLSessionTask *__autoreleasing *)pointerToTaskFromTask:(NSURLSessionTask * __autoreleasing *)task {
  // create a pointer to a task, since we can't have a nil value
  if (!task) {
    NSURLSessionTask *__autoreleasing pointer;
    NSURLSessionTask *__autoreleasing *replacement = &pointer;
    task = replacement;
  }
  return task;
}

- (AFPromise *)dataTaskWithRequest:(NSURLRequest *)request
                               task:(NSURLSessionTask * __autoreleasing *)task
{
  task = [self pointerToTaskFromTask:task];
  return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
    *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
      if (error) {
        resolve(error);
      }
      else {
        resolve(PMKManifold(response, responseObject));
      }
    }];
  }];
}

- (AFPromise *)uploadTaskWithRequest:(NSURLRequest *)request
                             fromFile:(NSURL *)fileURL
                             progress:(NSProgress * __autoreleasing *)progress
                           uploadTask:(NSURLSessionTask * __autoreleasing *)uploadTask
{
  uploadTask = [self pointerToTaskFromTask:uploadTask];
  return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
    *uploadTask = [self uploadTaskWithRequest:request fromFile:fileURL progress:progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
      if (error) {
        resolve(error);
      }
      else {
        resolve(PMKManifold(response, responseObject));
      }
    }];
  }];
}

- (AFPromise *)uploadTaskWithRequest:(NSURLRequest *)request
                             fromData:(NSData *)bodyData
                             progress:(NSProgress * __autoreleasing *)progress
                           uploadTask:(NSURLSessionTask * __autoreleasing *)uploadTask
{
  uploadTask = [self pointerToTaskFromTask:uploadTask];
  return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
    *uploadTask = [self uploadTaskWithRequest:request fromData:bodyData progress:progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
      if (error) {
        resolve(error);
      }
      else {
        resolve(PMKManifold(response, responseObject));
      }
    }];
  }];
}

- (AFPromise *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                     progress:(NSProgress * __autoreleasing *)progress
                                   uploadTask:(NSURLSessionTask * __autoreleasing *)uploadTask
{
  uploadTask = [self pointerToTaskFromTask:uploadTask];
  return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
    *uploadTask = [self uploadTaskWithStreamedRequest:request progress:progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
      if (error) {
        resolve(error);
      }
      else {
        resolve(PMKManifold(response, responseObject));
      }
    }];
  }];
}

- (AFPromise *)downloadTaskWithRequest:(NSURLRequest *)request
                               progress:(NSProgress * __autoreleasing *)progress
                            destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                           downloadTask:(NSURLSessionTask * __autoreleasing *)downloadTask
{
  downloadTask = [self pointerToTaskFromTask:downloadTask];
  return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
    *downloadTask = [self downloadTaskWithRequest:request progress:progress destination:destination completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
      if (error) {
        resolve(error);
      }
      else {
        resolve(PMKManifold(response, filePath));
      }
    }];
  }];
}

- (AFPromise *)downloadTaskWithResumeData:(NSData *)resumeData
                                  progress:(NSProgress * __autoreleasing *)progress
                               destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                              downloadTask:(NSURLSessionTask * __autoreleasing *)downloadTask
{
  downloadTask = [self pointerToTaskFromTask:downloadTask];
    return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        *downloadTask = [self downloadTaskWithResumeData:resumeData progress:progress destination:destination completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            if (error) {
                resolve(error);
            }
            else {
                resolve(PMKManifold(response, filePath));
            }
        }];
    }];
}


- (AFPromise *)POST:(NSString *)urlString parameters:(id)parameters
{
	return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
		[[self POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
			resolve(PMKManifold(responseObject, task));
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			resolve(error);
		}] resume];
	}];
}

<<<<<<< HEAD
- (AFPromise *)POSTMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
=======
- (PMKPromise *)POSTMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
	return [self operationSequenceWithType:AF_OPERATION_POST urls:urlStringsArray parameters:parametersArray];
}

- (PMKPromise *)POST:(NSString *)urlString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
	return [self operationSequenceWithType:AF_OPERATION_POST urls:urlStringsArray parameters:parametersArray];
}

- (AFPromise *)POST:(NSString *)urlString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
{
	return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
		[[self POST:urlString parameters:parameters constructingBodyWithBlock:block success:^(NSURLSessionDataTask *task, id responseObject) {
			resolve(PMKManifold(responseObject, task));
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			resolve(error);
		}] resume];
	}];
}


<<<<<<< HEAD
- (AFPromise *)GET:(NSString *)urlString parameters:(id)parameters
=======
- (PMKPromise *)GET:(NSString *)urlString parameters:(id)parameters
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
	return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
		[[self GET:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
			resolve(PMKManifold(responseObject, task));
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			resolve(error);
		}] resume];
	}];
}

<<<<<<< HEAD
- (AFPromise *)GETMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
=======
- (PMKPromise *)GETMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
	return [self operationSequenceWithType:AF_OPERATION_GET urls:urlStringsArray parameters:parametersArray];
}


- (AFPromise *)PUT:(NSString *)urlString parameters:(id)parameters
{
	return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
		[[self PUT:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
			resolve(PMKManifold(responseObject, task));
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			resolve(error);
		}] resume];
	}];
}

<<<<<<< HEAD
- (AFPromise *)PUTMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
=======
- (PMKPromise *)PUTMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
	return [self operationSequenceWithType:AF_OPERATION_PUT urls:urlStringsArray parameters:parametersArray];
}

- (PMKPromise *)HEAD:(NSString *)urlString parameters:(id)parameters
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
	return [self operationSequenceWithType:AF_OPERATION_PUT urls:urlStringsArray parameters:parametersArray];
}

- (AFPromise *)HEAD:(NSString *)urlString parameters:(id)parameters
{
	return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
		[[self HEAD:urlString parameters:parameters success:^(NSURLSessionDataTask *task) {
			resolve(task);
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			resolve(error);
		}] resume];
	}];
}

<<<<<<< HEAD
- (AFPromise *)HEADMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
=======
- (PMKPromise *)HEADMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
	return [self operationSequenceWithType:AF_OPERATION_HEAD urls:urlStringsArray parameters:parametersArray];
}

- (PMKPromise *)PATCH:(NSString *)urlString parameters:(id)parameters
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
	return [self operationSequenceWithType:AF_OPERATION_HEAD urls:urlStringsArray parameters:parametersArray];
}

- (AFPromise *)PATCH:(NSString *)urlString parameters:(id)parameters
{
	return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
		[[self PATCH:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
			resolve(PMKManifold(responseObject, task));
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			resolve(error);
		}] resume];
	}];
}

<<<<<<< HEAD
- (AFPromise *)PATCHMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
=======
- (PMKPromise *)PATCHMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
	return [self operationSequenceWithType:AF_OPERATION_PATCH urls:urlStringsArray parameters:parametersArray];
}



- (PMKPromise *)DELETE:(NSString *)urlString parameters:(id)parameters
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
	return [self operationSequenceWithType:AF_OPERATION_PATCH urls:urlStringsArray parameters:parametersArray];
}



- (AFPromise *)DELETE:(NSString *)urlString parameters:(id)parameters
{
	return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
		[[self DELETE:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
			resolve(PMKManifold(responseObject, task));
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			resolve(error);
		}] resume];
	}];
}

<<<<<<< HEAD
- (AFPromise *)DELETEMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
=======
- (PMKPromise *)DELETEMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
	return [self operationSequenceWithType:AF_OPERATION_DELETE urls:urlStringsArray parameters:parametersArray];
}




<<<<<<< HEAD
- (AFPromise *)operationSequenceWithType:(AF_OPERATION_KIND)operationKind urls:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
=======
- (PMKPromise *)operationSequenceWithType:(AF_OPERATION_KIND)operationKind urls:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
	assert (urlStringsArray.count == parametersArray.count);
	NSMutableArray *operations = [NSMutableArray array];
	
	for (int i=0; i<urlStringsArray.count; i++){
		NSString *urlString = urlStringsArray[i];
		NSDictionary *parameters = parametersArray[i];
		
<<<<<<< HEAD
		AFPromise *p = [self promiseForNetworkOperation:operationKind withURL:urlString andParameters:parameters];
		
		[operations addObject:p.then(^(id responseObject, NSURLSessionDataTask *task){
			return [AFPromise promiseWithValue:@{kPMKAFResponseObjectKey : responseObject, kPMKAFResponseTaskKey : task}];
		})];
	}
	
	return PMKWhen(operations);
=======
		PMKPromise *p = [self promiseForNetworkOperation:operationKind withURL:urlString andParameters:parameters];
		
		[operations addObject:p.then(^(id responseObject, NSURLSessionDataTask *task){
			return [PMKPromise promiseWithValue:@{kPMKAFResponseObjectKey : responseObject, kPMKAFResponseTaskKey : task}];
		})];
	}
	
	return [PMKPromise when:operations];
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
}



<<<<<<< HEAD
- (AFPromise *)promiseForNetworkOperation:(AF_OPERATION_KIND)operationKind withURL:(NSString *)urlString andParameters:(id)parameters
=======
- (PMKPromise *)promiseForNetworkOperation:(AF_OPERATION_KIND)operationKind withURL:(NSString *)urlString andParameters:(id)parameters
>>>>>>> f30d58a1cd87059c46b2552067896738766b04a3
{
	switch (operationKind) {
		case AF_OPERATION_GET:
			return [self GET:urlString parameters:parameters];
		case AF_OPERATION_DELETE:
			return [self DELETE:urlString parameters:parameters];
		case AF_OPERATION_PATCH:
			return [self PATCH:urlString parameters:parameters];
		case AF_OPERATION_POST:
			return [self POST:urlString parameters:parameters];
		case AF_OPERATION_PUT:
			return [self PUT:urlString parameters:parameters];
		case AF_OPERATION_HEAD:
			return [self HEAD:urlString parameters:parameters];
		default:
			break;
	}
	return nil;
}




@end



