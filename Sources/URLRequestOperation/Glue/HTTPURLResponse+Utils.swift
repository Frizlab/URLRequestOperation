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
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif



internal extension HTTPURLResponse {
	
	func hpn_value(forHTTPHeaderField headerName: String) -> String? {
		if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
			return value(forHTTPHeaderField: headerName)
		} else {
			/* If the OS is too old, we do the comparison manually… */
			guard let key = allHeaderFields.keys.first(where: { ($0 as? String)?.lowercased() == headerName.lowercased() }) else {
				return nil
			}
			return allHeaderFields[key] as? String
		}
	}
	
}
