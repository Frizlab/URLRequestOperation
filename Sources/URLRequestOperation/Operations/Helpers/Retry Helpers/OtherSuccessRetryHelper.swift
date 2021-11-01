import Foundation
#if canImport(os)
import os.log
#endif

import RetryingOperation



extension NSNotification.Name {
	
	public static let URLRequestOperationDidSucceedURLSessionTask = NSNotification.Name(rawValue: "com.happn.URLRequestOperation.DidSucceedURLSessionTask")
	public static let URLRequestOperationDidSucceedOperation = NSNotification.Name(rawValue: "com.happn.URLRequestOperation.DidSucceedOperation")
	
}


public final class OtherSuccessRetryHelper : RetryHelper {
	
	public static let requestSucceededNotifUserInfoHostKey = "Host"
	
	public let host: String
	
	public init?(host: String?, monitorSessionTaskSuccessInsteadOfOperationSuccess: Bool = false, operation: URLRequestOperation) {
		guard let host = host else {return nil}
		self.host = host
		self.notifName = monitorSessionTaskSuccessInsteadOfOperationSuccess ? .URLRequestOperationDidSucceedURLSessionTask : .URLRequestOperationDidSucceedOperation
		self.operation = operation
	}
	
	public func setup() {
		assert(otherSuccessObserver == nil)
		otherSuccessObserver = NotificationCenter.default.addObserver(forName: notifName, object: nil, queue: nil, using: { notif in
			let succeededHost = notif.userInfo?[Self.requestSucceededNotifUserInfoHostKey] as? String
			guard succeededHost == self.host else {return}
			
#if canImport(os)
			if #available(macOS 10.12, tvOS 10.0, iOS 10.0, watchOS 3.0, *) {
				Conf.oslog.flatMap{ os_log("URLOpID %{public}@: Got an URL operation succeeded with same host as me. Forcing retrying sooner.", log: $0, type: .debug, String(describing: self.operation.urlOperationIdentifier)) }}
#endif
			Conf.logger?.debug("Got an URL operation succeeded with same host as me. Forcing retrying sooner.", metadata: [LMK.operationID: "\(self.operation.urlOperationIdentifier)"])
			self.operation.retry(in: NetworkErrorRetryProvider.exponentialBackoffTimeForIndex(1))
		})
	}
	
	public func teardown() {
		NotificationCenter.default.removeObserver(otherSuccessObserver! /* Internal error if observer is nil */, name: notifName, object: nil)
		otherSuccessObserver = nil
	}
	
	private let operation: URLRequestOperation
	
	private let notifName: Notification.Name
	private var otherSuccessObserver: NSObjectProtocol?
	
}