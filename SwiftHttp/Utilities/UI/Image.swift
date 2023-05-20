//
//  Image.swift
//  SwiftHttp
//
//  Created by 吴书敏 on 2023/5/12.
//

import Foundation
import SwiftUI
import Kingfisher
import UIKit

extension Image {
    init(kfImage: KFCrossPlatformImage) {
        self.init(uiImage: kfImage)
    }
}


