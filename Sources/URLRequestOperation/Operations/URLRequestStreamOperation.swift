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

import RetryingOperation



@available(*, unavailable, message: "Not implemented yet")
public final class URLRequestStreamOperation : RetryingOperation, URLRequestOperation, @unchecked Sendable {
	
#if DEBUG
	public let urlOperationIdentifier: Int
#else
	public let urlOperationIdentifier: UUID
#endif
	
	public override init() {
#if DEBUG
		self.urlOperationIdentifier = LatestURLOpIDContainer.opIdQueue.sync{
			LatestURLOpIDContainer.latestURLOperationIdentifier &+= 1
			return LatestURLOpIDContainer.latestURLOperationIdentifier
		}
#else
		self.urlOperationIdentifier = UUID()
#endif
	}
	
}
