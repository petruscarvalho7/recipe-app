//
//  TagLayout.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 16/08/23.
//

import SwiftUI

struct TagLayout: Layout {
    // properties
    var alignment: Alignment = .center
    
    // spacing
    var spacing: CGFloat = 10
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var height: CGFloat = 0
        let rows = generateRows(maxWidth, proposal, subviews)
        
        for (index, row) in rows.enumerated() {
            if index == (rows.count - 1) {
                height += row.maxHeight(proposal)
            } else {
                height += row.maxHeight(proposal) + spacing
            }
        }
        
        return .init(width: maxWidth, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var origin = bounds.origin
        let maxWidth = bounds.width
        let rows = generateRows(maxWidth, proposal, subviews)
        
        for row in rows {
            // alignments
            let leading: CGFloat = bounds.maxX - maxWidth
            let trailing = bounds.maxX - (row.reduce(CGFloat.zero) { partialResult, view in
                let width = view.sizeThatFits(proposal).width
                
                if view == row.last {
                    // no spacing
                    return partialResult + width
                }
                
                return partialResult + width + spacing
            })
            
            let center = (trailing + leading) / 2
            
            // resetting origin x
            origin.x = (alignment == .leading
                            ? leading
                            : alignment == .trailing
                                ? trailing
                                : center
            )
            
            for view in row {
                let viewSize = view.sizeThatFits(proposal)
                view.place(at: origin, proposal: proposal)
                // updating origin x
                origin.x += (viewSize.width + spacing)
            }
            
            // updating origin y
            origin.y += (row.maxHeight(proposal) + spacing)
        }
    }

    fileprivate func addItem(_ row: inout [LayoutSubview], _ view: LayoutSubviews.Element, _ origin: inout CGPoint, _ viewSize: CGSize) {
        row.append(view)
        // updating origin
        origin.x += (viewSize.width + spacing)
    }
    
    // generating rows to available size
    func generateRows(_ maxWidth: CGFloat, _ proposal: ProposedViewSize, _ subviews: Subviews) -> [[LayoutSubviews.Element]] {
        var row: [LayoutSubviews.Element] = []
        var rows: [[LayoutSubviews.Element]] = []
        
        // origin point
        var origin = CGRect.zero.origin
        
        for view in subviews {
            let viewSize = view.sizeThatFits(proposal)
            
            // pushing a new row
            if (origin.x + viewSize.width + spacing) > maxWidth {
                rows.append(row)
                row.removeAll()
                // resetting X origin when it needs to start from left to right
                origin.x = 0
                addItem(&row, view, &origin, viewSize)
            } else {
                // add item on same row
                addItem(&row, view, &origin, viewSize)
            }
        }
        
        // checking for any exhaust row
        if !row.isEmpty {
            rows.append(row)
            row.removeAll()
        }
        
        return rows
    }
    
}

extension [LayoutSubviews.Element] {
    func maxHeight(_ proposal: ProposedViewSize) -> CGFloat {
        return self.compactMap { view in
            return view.sizeThatFits(proposal).height
        }
        .max() ?? 0
    }
}
