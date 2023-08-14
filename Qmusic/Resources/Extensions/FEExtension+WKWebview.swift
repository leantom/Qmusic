//
//  FEExtension+WKWebview.swift
//  FEMobile
//
//  Created by Manoj Kumar on 02/11/22.
//

import Foundation
import WebKit

extension WKWebView{
    func removeDoubleTapGesture(){
        for subview in self.scrollView.subviews {
            let recognizers = subview.gestureRecognizers?.filter{$0 is UITapGestureRecognizer}
            recognizers?.forEach{recognizer in
                let tapRecognizer = recognizer as! UITapGestureRecognizer
                if tapRecognizer.numberOfTapsRequired == 2 && tapRecognizer.numberOfTouchesRequired == 1 {
                    subview.removeGestureRecognizer(recognizer)
                }
            }
        }
    }
}
