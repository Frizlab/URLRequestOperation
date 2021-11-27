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



public struct RecoverHTTPStatusCodeCheckErrorResultProcessor : ResultProcessor {
	
	public typealias SourceType = Error
	public typealias ResultType = Data
	
	public func transform(source: Error, urlResponse: URLResponse, handler: @escaping (Result<Data, Error>) -> Void) {
		handler(Result{
			guard
				let urlOpError = source as? Err,
				case let .unexpectedStatusCode(_, dataInError) = urlOpError,
				let data = dataInError
			else {
				throw source
			}
			return data
		})
	}
	
}
