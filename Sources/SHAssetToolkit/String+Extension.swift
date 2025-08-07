//
//  String+Extension.swift
//  SHAssetToolkit
//
//  Created by Sajjad Hajavi on 8/7/25.
//

import Foundation

extension String {
    public var asUrl: URL {
        let urlStr = self.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: urlStr) else {
            return URL.init(fileURLWithPath:  "")
        }
        return url
    }
}
