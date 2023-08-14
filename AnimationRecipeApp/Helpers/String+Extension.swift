//
//  String+Extension.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 14/08/23.
//

import Foundation

extension String
{
    func isEmail() -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}
