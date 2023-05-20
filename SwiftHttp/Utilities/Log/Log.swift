//
//  Log.swift
//  SwiftHttp
//
//  Created by 吴书敏 on 2023/3/3.
//

import Foundation
import SwiftUI

func dPrint(item: @autoclosure () -> Any) {
    #if DEBUG
    print(item())
    #endif
}


extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

extension View {
    func debug() -> Self {
        print(Mirror(reflecting: self).subjectType)
        return self
    }
}
