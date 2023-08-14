//
//  ObjectExt.swift
//  FEMobile
//
//  Created by zakaru on 02/08/2021.
//

import Foundation

extension NSObject {

	/// Return the identifier of this object
	var identifier: String {
		return String(describing: type(of: self))
	}

	/// Return the identifier of this object
	static var identifier: String {
		return String(describing: self)
	}
}
