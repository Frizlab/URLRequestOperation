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

import MediaType



/** All of the errors thrown by the module should have this type. */
public enum URLRequestOperationError : Error {
	
	case operationNotFinished
	case operationCancelled
	
	/** Error from ``HTTPStatusCodeURLResponseValidator`` or ``HTTPStatusCodeCheckResultProcessor`` if status code is not one of the expected values. */
	case unexpectedStatusCode(Int?, httpBody: Data?)
	
	/** Error from ``URLMoveResultProcessor`` if the destination file already exists and the move behavior is ``failIfDestinationExists`` */
	case downloadDestinationExists
	
	/** Error from an ``HTTPContentDecoder`` when given object has unsupported media type. */
	case invalidMediaType(MediaType)
	
	/** Error from ``DecodeHTTPContentResultProcessor`` if URL response does not have or have an invalid content type (or is not an HTTP URL response). */
	case noOrInvalidContentType(URLResponse)
	
	/** Error from ``DecodeHTTPContentResultProcessor`` if no decoders are configured for the content type in the response. */
	case noDecoderForContentType(MediaType)
	
	/**
	 One of these cases that should never happen:
	 - URL response **and** error are `nil` from underlying session task;
	 - Task’s response is `nil` in `urlSession(:downloadTask:didFinishDownloadingTo:)`.
	 
	 We provide this in order to avoid crashing instead if one of these do happen.
	 In debug mode, we do crash (assertion failure). */
	case invalidURLSessionContract
	
}

typealias Err = URLRequestOperationError
