//
//  YZGRequest.h
//
//  Copyright (c) 2012-2016 YZGNetwork https://github.com/yuantiku
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "BaseParam.h"
NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const YZGRequestValidationErrorDomain;

NS_ENUM(NSInteger) {
YZGRequestValidationErrorInvalidStatusCode = -8,
YZGRequestValidationErrorInvalidJSONFormat = -9,
};

///  HTTP Request method.
typedef NS_ENUM(NSInteger, YZGRequestMethod) {
    YZGRequestMethodGET = 0,
    YZGRequestMethodPOST,
};

///  Request serializer type.
typedef NS_ENUM(NSInteger, YZGRequestSerializerType) {
    YZGRequestSerializerTypeHTTP = 0,
    YZGRequestSerializerTypeJSON,
};

///  Response serializer type, which determines response serialization process and
///  the type of `responseObject`.
typedef NS_ENUM(NSInteger, YZGResponseSerializerType) {
    /// NSData type
    YZGResponseSerializerTypeHTTP,
    /// JSON object type
    YZGResponseSerializerTypeJSON,
    /// NSXMLParser type
    YZGResponseSerializerTypeXMLParser,
};

///  Request priority
typedef NS_ENUM(NSInteger, YZGRequestPriority) {
    YZGRequestPriorityLow = -4L,
    YZGRequestPriorityDefault = 0,
    YZGRequestPriorityHigh = 4,
};
    
@class YZGRequest;
@protocol AFMultipartFormData;

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
typedef void (^AFURLSessionTaskProgressBlock)(NSProgress *);
typedef void(^YZGRequestCompletionBlock)(__kindof YZGRequest *request);

///  The YZGRequestDelegate protocol defines several optional methods you can use
///  to receive network-related messages. All the delegate methods will be called
///  on the main queue.
@protocol YZGRequestDelegate <NSObject>

@optional
///  Tell the delegate that the request has finished successfully.
///
///  @param request The corresponding request.
- (void)requestFinished:(__kindof YZGRequest *)request;

///  Tell the delegate that the request has failed.
///
///  @param request The corresponding request.
- (void)requestFailed:(__kindof YZGRequest *)request;

@end
    
///  YZGRequest is the abstract class of network request. It provides many options
///  for constructing request. It's the base class of `YZGRequest`.
@interface YZGRequest : NSObject

#pragma mark - Task Information
///=============================================================================
/// @name Task Information
///=============================================================================

///  The underlying NSURLSessionTask.
///
///  @warning This value is actually nil and should not be accessed before the request starts.
@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;

///  Shortcut for `requestTask.currentRequest`.
@property (nonatomic, strong, readonly) NSURLRequest *currentRequest;

///  Shortcut for `requestTask.originalRequest`.
@property (nonatomic, strong, readonly) NSURLRequest *originalRequest;

///  Shortcut for `requestTask.response`.
@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;

///  The response status code.
@property (nonatomic, readonly) NSInteger responseStatusCode;

///  The response header fields.
@property (nonatomic, strong, readonly, nullable) NSDictionary *responseHeaders;

///  This serialized response object. The actual type of this object is determined by
///  `YZGResponseSerializerType`. Note this value can be nil if request failed.
///
///  @discussion If `resumableDownloadPath` and DownloadTask is using, this value will
///              be the path to which file is successfully saved (NSURL), or nil if request failed.
@property (nonatomic, strong, readwrite, nullable) id responseObject;

///  This serialized model object. The actual type of this object is determined by
///  `ModelClassName`. Note this value can be nil if request failed.
@property (nonatomic, strong, readwrite, nullable) id item;

///  The @property BaseItem *item will be serialized to model with responseObject
-(void)serializedResponseObjectToModel;

///  This error can be either serialization error or network error. If nothing wrong happens
///  this value will be nil.
@property (nonatomic, strong, readwrite, nullable) NSError *error;
///  If YES the  type of error is network error(server or net).
@property (nonatomic, getter=isNetworkError) BOOL networkError;

///  Return cancelled state of request task.
@property (nonatomic, readonly, getter=isCancelled) BOOL cancelled;

///  Executing state of request task.
@property (nonatomic, readonly, getter=isExecuting) BOOL executing;


#pragma mark - Delegate & CallBack & Download & Upload Configuration
///=============================================================================
/// @name Delegate & CallBack & Download & Upload Configuration
///=============================================================================

///  The delegate object of the request. If you choose block style callback you can ignore this.
///  Default is nil.
@property (nonatomic, weak, nullable) id<YZGRequestDelegate> delegate;

///  The success callback. Note if this value is not nil and `requestFinished` delegate method is
///  also implemented, both will be executed but delegate method is first called. This block
///  will be called on the main queue.
@property (nonatomic, copy, nullable) YZGRequestCompletionBlock successCompletionBlock;

///  The failure callback. Note if this value is not nil and `requestFailed` delegate method is
///  also implemented, both will be executed but delegate method is first called. This block
///  will be called on the main queue.
@property (nonatomic, copy, nullable) YZGRequestCompletionBlock failureCompletionBlock;

///  This can be use to construct HTTP body when needed in POST request. Default is nil.
@property (nonatomic, copy, nullable) AFConstructingBlock constructingBodyBlock;

///  This value is used to perform download request. Default is NO.
///  If assign YES to this property the HTTP request method is GET.
///
@property (nonatomic, assign) BOOL isDownload;

///  You can use this block to track the download progress. See also `resumableDownloadPath`.
@property (nonatomic, copy, nullable) AFURLSessionTaskProgressBlock resumableDownloadProgressBlock;

///  This value is used to perform resumable download request. Default is nil.
///
///  @discussion NSURLSessionDownloadTask is used when this value is not nil.
///              The exist file at the path will be removed before the request starts. If request succeed, file will
///              be saved to this path automatically, otherwise the response will be saved to `responseData`
///              and `responseString`. For this to work, server must support `Range` and response with
///              proper `Last-Modified` and/or `Etag`. See `NSURLSessionDownloadTask` for more detail.
@property (nonatomic, strong, nullable) NSString *resumableDownloadPath;

///  Nil out both success and failure callback blocks.
- (void)clearCompletionBlock;

#pragma mark - Request Action

-(void)start;

///  Convenience method to start the request with block callbacks.
- (void)startWithCompletionBlockWithSuccess:(nullable YZGRequestCompletionBlock)success
                                    failure:(nullable YZGRequestCompletionBlock)failure;

-(void)stop;

#pragma mark - Request Configuration

///  The baseURL of request. This should only contain the host part of URL, e.g., http://www.example.com.
///  See also `requestUrl`
- (NSString *)baseUrl;

///  The URL path of request. This should only contain the path part of URL, e.g., /v1/user. See alse `baseUrl`.
///
///  @discussion This will be concated with `baseUrl` using [NSURL URLWithString:relativeToURL].
///              Because of this, it is recommended that the usage should stick to rules stated above.
///              Otherwise the result URL may not be correctly formed. See also `URLString:relativeToURL`
///              for more information.
///
///              Additionaly, if `requestUrl` itself is a valid URL, it will be used as the result URL and
///              `baseUrl` will be ignored.
@property (nonatomic , copy) NSString *requestUrl;

///  Additional request argument.
@property (nonatomic , strong) id requestParam;

///  The priority of the request. Effective only on iOS 8+. Default is `YZGRequestPriorityDefault`.
@property (nonatomic) YZGRequestPriority requestPriority;

///  Requset timeout interval. Default is 30s.
///
///  @discussion When using `resumableDownloadPath`(NSURLSessionDownloadTask), the session seems to completely ignore
///              `timeoutInterval` property of `NSURLRequest`. One effective way to set timeout would be using
///              `timeoutIntervalForResource` of `NSURLSessionConfiguration`.
- (NSTimeInterval)requestTimeoutInterval;


///  HTTP request method.
@property (nonatomic , assign) YZGRequestMethod requestMethod;

///  Request serializer type.
- (YZGRequestSerializerType)requestSerializerType;

///  Username and password used for HTTP authorization. Should be formed as @[@"Username", @"Password"].
- (nullable NSArray<NSString *> *)requestAuthorizationHeaderFieldArray;

///  Additional HTTP request header field.
@property (nonatomic , strong) NSDictionary<NSString *,NSString *> *requestHeaderFieldValueDictionary;

///  Whether the request is allowed to use the cellular radio (if present). Default is YES.
- (BOOL)allowsCellularAccess;

#pragma mark - Response Configuration
///  Response serializer type. See also `responseObject`.
- (YZGResponseSerializerType)responseSerializerType;

/**
 The acceptable MIME types for responses. When non-`nil`, responses with a `Content-Type` with MIME types that do not intersect with the set will result in an error during validation.
 */
- (NSSet <NSString *> *)acceptableContentTypes;

///  This validator will be used to test if `responseStatusCode` is valid.
- (BOOL)statusCodeValidator;

///  The validator will be used to test if `responseObject` is correctly formed.
- (BOOL)jsonValidator;

/// Convenient initialization
-(instancetype)initWithRequestUrl:(NSString *)requestUrl withRequestParam:(nullable id)requestParam;

-(instancetype)initWithRequestUrl:(NSString *)requestUrl;;

-(instancetype)initWithRequestParam:(nullable id)requestParam;

@end
    
NS_ASSUME_NONNULL_END
