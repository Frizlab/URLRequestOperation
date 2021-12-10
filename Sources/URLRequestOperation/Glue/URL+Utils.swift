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

import FormURLEncodedEncoding



internal extension URL {
	
	func addingQueryParameters<Parameters : Encodable>(from parameters: Parameters, encoder: URLQueryEncoder = FormURLEncodedEncoder()) throws -> URL {
		let encoded: String = try encoder.encode(parameters)
		/* We do the URL/URLComponents trip, because otherwise it’s annoying to manage the fragment.
		 * If the fragment were not there, I’d have simply appended the encoded parameters to the URL, w/ a “?” or a “&” before depending on whether query is nil. */
		guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
			throw Err.failedConversionBetweenURLAndURLComponents
		}
		components.percentEncodedQuery = (components.percentEncodedQuery.flatMap{ $0 + "&" } ?? "") + encoded
		guard let ret = components.url else {
			throw Err.failedConversionBetweenURLAndURLComponents
		}
		return ret
	}
	
	func addingQueryParameters<Parameters : Encodable>(from parameters: Parameters?, encoder: URLQueryEncoder = FormURLEncodedEncoder()) throws -> URL {
		guard let parameters = parameters else {
			return self
		}
		return try addingQueryParameters(from: parameters, encoder: encoder)
	}
	
	/** Simply calls `appendingPathComponent` if path is non-nil, else returns self. */
	func appendingPath(_ path: String?) -> URL {
		path.flatMap{ appendingPathComponent($0) } ?? self
	}
	
	/** Throws if any of the given component contains a path separator. */
	func appendingPathComponentsSafely(_ components: [String]) throws -> URL {
		/* Let’s check the given path is valid (does not contain a path separator).
		 * Note: We hardcode the path separator for now, but we shouldn’t. */
		if let invalid = components.first(where: { $0.range(of: "/") != nil }) {
			throw Err.invalidPathComponent(invalid)
		}
		return components.reduce(self, { reduced, new in reduced.appendingPathComponent(new) })
	}
	
}
