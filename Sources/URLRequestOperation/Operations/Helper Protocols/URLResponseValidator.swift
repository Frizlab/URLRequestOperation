import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif



public protocol URLResponseValidator {
	
	/**
	 Method called to validate the URL response.
	 Must return `nil` if the response is ok.
	 
	 An example of use for a response validator would be to verify we get a 2xx from the server.
	 This is useful when downloading an image from a server for instance, but much less so when calling an API.
	 Usually an API will return useful content in the response body even when not returning a 2xx (e.g. an “error” field explaining why the request failed).
	 If you use an URL response validator, the body will not be returned (and might even not be downloaded at all) by the `URLRequestOperation`.
	 
	 The retry providers will still be called if this method returns an error.
	 
	 - Note: The closest API to this one in the data task session delegate is asynchronous
	 (method is `urlSession(:,dataTask:,didReceive:,completionHandler:)`).
	 
	 The asynchronicity allows the dev to let the user choose whether he allows downloading a file,
	 if the response indicates the data task should be transformed to a download task for instance
	 ([see this Developer Forums post](https://developer.apple.com/forums/thread/693645?answerId=693559022#693559022)).
	 
	 URLRequestOperation’s goal is not to replace `URLSession`’s delegate.
	 If you need to convert your task to a download task, or need to be async in general when validating the response,
	 you should use the session’s delegate. */
	func validate(urlResponse: URLResponse) -> Error?
	
}
