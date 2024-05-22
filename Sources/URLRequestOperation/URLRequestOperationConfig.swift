/*
Copyright 2019-2021 happn

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License. */

import Foundation
#if canImport(OSLog)
/* The Swift compiler complains the annotation is unused, but it actually is, inside an expansion of a macro. */
@preconcurrency import OSLog
#endif

import GlobalConfModule
import Logging

import FormURLEncodedCoder



public extension ConfKeys {
	/* URLRequestOperation conf namespace declaration. */
	struct URLRequestOperation {}
	var urlRequestOperation: URLRequestOperation {URLRequestOperation()}
}


extension ConfKeys.URLRequestOperation {
	
#if canImport(os)
 #if swift(>=6.0)
  /* See <https://developer.apple.com/forums/thread/747816?answerId=781922022#781922022>. */
  #warning("Reevaluate whether unsafeNonIsolated is still necessary.")
 #endif
	#declareConfKey("oslog",  OSLog?         .self, unsafeNonIsolated: true, defaultValue: OSLog(subsystem: "com.happn.RetryingOperation", category: "Main"))
	#declareConfKey("logger", Logging.Logger?.self,                          defaultValue: nil)
#else
	#declareConfKey("logger", Logging.Logger?.self, defaultValue: .init(label: "me.frizlab.URLRequestOperation"))
#endif
	
	#declareConfKey("defaultAPIResponseDecoders",         [HTTPContentDecoder].self, defaultValue: [SendableJSONDecoderForHTTPContent()])
	#declareConfKey("defaultAPIRequestBodyEncoder",       HTTPContentEncoder  .self, defaultValue: SendableJSONEncoderForHTTPContent())
	#declareConfKey("defaultAPIRequestParametersEncoder", URLQueryEncoder     .self, defaultValue: FormURLEncodedEncoder())
	/** Before these retry providers, there will always be retry providers to block content decoding or unexpected status code errors. */
	#declareConfKey("defaultAPIRetryProviders",       [RetryProvider].self, defaultValue: [NetworkErrorRetryProvider()])
	#declareConfKey("defaultAPIRetryableStatusCodes", Set<Int>       .self, defaultValue: [503])
	
	/** Before these retry providers, there will always be retry providers to block unexpected status code errors. */
	#declareConfKey("defaultDataRetryProviders",       [RetryProvider].self, defaultValue: [NetworkErrorRetryProvider()])
	#declareConfKey("defaultDataRetryableStatusCodes", Set<Int>       .self, defaultValue: [503])
	
	/** Before these retry providers, there will always be retry providers to block image conversion failure or unexpected status code errors. */
	#declareConfKey("defaultImageRetryProviders",       [RetryProvider].self, defaultValue: [NetworkErrorRetryProvider()])
	#declareConfKey("defaultImageRetryableStatusCodes", Set<Int>       .self, defaultValue: [503])
	
	#declareConfKey("defaultStringEncoding",             String.Encoding.self, defaultValue: .utf8)
	/** Before these retry providers, there will always be retry providers to block string conversion failure or unexpected status code errors. */
	#declareConfKey("defaultStringRetryProviders",       [RetryProvider].self, defaultValue: [NetworkErrorRetryProvider()])
	#declareConfKey("defaultStringRetryableStatusCodes", Set<Int>       .self, defaultValue: [503])
	
	/** Before these retry providers, there will always be retry providers to block download specific error or unexpected status code errors. */
	#declareConfKey("defaultDownloadRetryProviders",       [RetryProvider].self, defaultValue: [NetworkErrorRetryProvider()])
	#declareConfKey("defaultDownloadRetryableStatusCodes", Set<Int>       .self, defaultValue: [503])
	
	#declareConfKey("networkRetryProviderDefaultNumberOfRetries", Int?          .self, defaultValue: 7)
	#declareConfKey("networkRetryProviderBackoffTable",           [TimeInterval].self, defaultValue: [1, 3, 15, 27, 42, 60, 60 * 60, 6 * 60 * 60] as [TimeInterval])
	
	/**
	 When sending data to a server, should we log it?
	 
	 `URLRequestOperation` can log all the requests that are started at log level trace.
	 This variable controls when the requests should be logged depending on the request’s body size.
	 
	 If variable is set to `nil`, requests are never logged.
	 Unless in debug mode, you should leaving it `nil`.
	 
	 If non-`nil`, all requests are logged, and the body is logged only if its size is lower than the value.
	 For requests whose body is bigger than the value, the body size is printed instead of the body.
	 
	 Set the value to `.max` to log _everything_.
	 This is dangerous though as you can get very big logs depending on your usage. */
	#declareConfKey("maxRequestBodySizeToLog", Int?.self, defaultValue: nil)
	/**
	 When receiving data from a server, should we log it?
	 
	 `URLRequestOperation` can log all the responses that are received at log level trace.
	 This variable controls when the responses should be logged depending on the response’s data size.
	 
	 If variable is set to `nil`, responses are never logged.
	 Unless in debug mode, you should leaving it `nil`.
	 
	 If non-`nil`, all responses are logged, and the body is logged only if its size is lower than the value.
	 For responses whose body is bigger than the value, the body size is printed instead of the body.
	 
	 Set the value to `.max` to log _everything_.
	 This is dangerous though as you can get very big logs depending on your usage. */
	#declareConfKey("maxResponseBodySizeToLog", Int?.self, defaultValue: nil)
	/** Log everything URL Session related in the file at the given URL. */
//	#declareConfKey("debugLogURL", URL?.self, defaultValue: nil)
	
}


internal extension Conf {
	
	static var oslog:  OSLog?          {Conf[\.urlRequestOperation.oslog]}
	static var logger: Logging.Logger? {Conf[\.urlRequestOperation.logger]}
	
	static var defaultAPIResponseDecoders:         [HTTPContentDecoder] {Conf[\.urlRequestOperation.defaultAPIResponseDecoders]}
	static var defaultAPIRequestBodyEncoder:       HTTPContentEncoder   {Conf[\.urlRequestOperation.defaultAPIRequestBodyEncoder]}
	static var defaultAPIRequestParametersEncoder: URLQueryEncoder      {Conf[\.urlRequestOperation.defaultAPIRequestParametersEncoder]}
	
	static var defaultAPIRetryProviders:       [RetryProvider] {Conf[\.urlRequestOperation.defaultAPIRetryProviders]}
	static var defaultAPIRetryableStatusCodes: Set<Int>        {Conf[\.urlRequestOperation.defaultAPIRetryableStatusCodes]}
	
	static var defaultDataRetryProviders:       [RetryProvider] {Conf[\.urlRequestOperation.defaultDataRetryProviders]}
	static var defaultDataRetryableStatusCodes: Set<Int>        {Conf[\.urlRequestOperation.defaultDataRetryableStatusCodes]}
	
	static var defaultImageRetryProviders:       [RetryProvider] {Conf[\.urlRequestOperation.defaultImageRetryProviders]}
	static var defaultImageRetryableStatusCodes: Set<Int>        {Conf[\.urlRequestOperation.defaultImageRetryableStatusCodes]}
	
	static var defaultStringEncoding:             String.Encoding {Conf[\.urlRequestOperation.defaultStringEncoding]}
	static var defaultStringRetryProviders:       [RetryProvider] {Conf[\.urlRequestOperation.defaultStringRetryProviders]}
	static var defaultStringRetryableStatusCodes: Set<Int>        {Conf[\.urlRequestOperation.defaultStringRetryableStatusCodes]}
	
	static var defaultDownloadRetryProviders:       [RetryProvider] {Conf[\.urlRequestOperation.defaultDownloadRetryProviders]}
	static var defaultDownloadRetryableStatusCodes: Set<Int>        {Conf[\.urlRequestOperation.defaultDownloadRetryableStatusCodes]}
	
	static var networkRetryProviderDefaultNumberOfRetries: Int?           {Conf[\.urlRequestOperation.networkRetryProviderDefaultNumberOfRetries]}
	static var networkRetryProviderBackoffTable:           [TimeInterval] {Conf[\.urlRequestOperation.networkRetryProviderBackoffTable]}
	
	static var maxRequestBodySizeToLog: Int? {Conf[\.urlRequestOperation.maxRequestBodySizeToLog]}
	
	static var maxResponseBodySizeToLog: Int? {Conf[\.urlRequestOperation.maxResponseBodySizeToLog]}
	
}
