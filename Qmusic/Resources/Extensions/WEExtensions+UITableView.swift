//
//  WEExtensions+UITableView.swift
//  facepay_v3
//
//  Created by Nguyen Thanh Duc on 10/12/2020.
//

import Foundation
import UIKit

extension UITableView {
    func setNoDataPlaceholder(view: UIView) {
        self.isScrollEnabled = false
        view.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        self.backgroundView = view
        self.separatorStyle = .none
        self.layoutIfNeeded()
    }
    
    func removeNoDataPlaceholder() {
        self.isScrollEnabled = true
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
//    var isAtBottom: Bool {
//        return contentOffset.y >= verticalOffsetForBottom - 80
//    }
    
    var isAtBottom: Bool {
        return contentOffset.y >= (contentSize.height - self.bounds.size.height)
    }
    
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}

extension UITableView{
    func customise(backgroundColor: UIColor? = UIColor.white, separatorStyle: UITableViewCell.SeparatorStyle = .none, removeFooter: Bool = true, rowHeight: CGFloat = UITableView.automaticDimension, showVerticalIndicator: Bool = false){
        self.separatorStyle = separatorStyle
        if removeFooter{
            self.tableFooterView = UIView()
        }
        self.rowHeight = rowHeight
        self.backgroundColor = backgroundColor
        self.showsVerticalScrollIndicator = false
        self.scrollIndicatorInsets = .zero
    }
}

extension UITableViewCell{
    func removeSelectionStyle(){
        self.selectionStyle = .none
    }
}
