/*
Copyright 2021 happn

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



public extension URLRequestDataOperation {
	
	static func forData(
		urlRequest: URLRequest, session: URLSession = .shared,
		requestProcessors: [RequestProcessor] = [], retryProviders: [RetryProvider] = [NetworkErrorRetryProvider()]
	) -> URLRequestDataOperation<ResultType> where ResultType == Data {
		return URLRequestDataOperation<Data>(
			request: urlRequest, session: session,
			requestProcessors: requestProcessors,
			urlResponseValidators: [HTTPStatusCodeURLResponseValidator()],
			resultProcessor: .identity(),
			retryProviders: [UnretriedErrorsRetryProvider.forStatusCodes()] + retryProviders
		)
	}
	
	static func forData(
		url: URL, headers: [String: String?] = [:], cachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy, session: URLSession = .shared,
		requestProcessors: [RequestProcessor] = [], retryProviders: [RetryProvider] = [NetworkErrorRetryProvider()]
	) -> URLRequestDataOperation<ResultType> where ResultType == Data {
		var request = URLRequest(url: url, cachePolicy: cachePolicy)
		for (key, val) in headers {request.setValue(val, forHTTPHeaderField: key)}
		return Self.forData(
			urlRequest: request, session: session,
			requestProcessors: requestProcessors, retryProviders: retryProviders
		)
	}
	
}