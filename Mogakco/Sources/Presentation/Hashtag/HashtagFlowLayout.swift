//
//  HashtagFlowLayout.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

class HashtagFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return [] }
        
        for (index, value) in attributes.enumerated() where attributes[index].representedElementCategory == .cell {
                if value.frame.origin.x == 0 { continue }
                value.frame.origin.x = attributes[index - 1].frame.maxX + minimumInteritemSpacing
        }
        return attributes
    }
}
