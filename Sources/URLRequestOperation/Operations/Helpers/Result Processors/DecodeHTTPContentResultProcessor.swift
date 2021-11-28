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

import MediaType



/** Throws ``DecodeHTTPContentResultProcessorError`` errors. */
public struct DecodeHTTPContentResultProcessor<ResultType : Decodable> : ResultProcessor {
	
	public typealias SourceType = Data
	
	public let decoders: [HTTPContentDecoder]
	
	public let processingQueue: BlockDispatcher
	
	public init(jsonDecoder: JSONDecoder, processingQueue: BlockDispatcher = SyncBlockDispatcher()) {
		self.decoders = [jsonDecoder]
		self.processingQueue = processingQueue
	}
	
	public init(decoders: [HTTPContentDecoder], processingQueue: BlockDispatcher = SyncBlockDispatcher()) {
		self.decoders = decoders
		self.processingQueue = processingQueue
	}
	
	public func transform(source: Data, urlResponse: URLResponse, handler: @escaping (Result<ResultType, Error>) -> Void) {
		/* O(n) or less, n being the number of headers in the response + the number of decoders,
		 * both of which are always small, so outside of processing queue. */
		guard let httpResponse = urlResponse as? HTTPURLResponse,
				let contentType = httpResponse.hpn_value(forHTTPHeaderField: "content-type").flatMap(MediaType.init)
		else {
			return handler(.failure(MyErr.noOrInvalidContentType(urlResponse)))
		}
		guard let decoder = decoders.first(where: { $0.canDecodeHTTPContent(mediaType: contentType) }) else {
			return handler(.failure(MyErr.noDecoderForContentType(contentType)))
		}
		
		/* Now we process stuff, let’s jump to the processing queue. */
		processingQueue.execute{ handler(Result{
			return try decoder.decodeHTTPContent(ResultType.self, from: source, mediaType: contentType)
		}.mapError{ MyErr.dataConversionFailed(source, $0) })}
	}
	
}


public enum DecodeHTTPContentResultProcessorError : Error {
	
	/** The URL response does not have or have an invalid content type (or is not an HTTP URL response). */
	case noOrInvalidContentType(URLResponse)
	
	/** No decoders are configured for the content type in the response. */
	case noDecoderForContentType(MediaType)
	
	/** Error for ``DecodeDataResultProcessor`` and ``DecodeHTTPContentResultProcessor``. */
	case dataConversionFailed(Data, Error?)
	
}

private typealias MyErr = DecodeHTTPContentResultProcessorError
