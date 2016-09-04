//
//  CollectionViewDataSource.swift
//  Spyglass
//
//  Created by Alexsander Akers on 9/4/16.
//  Copyright © 2016 Pandamonia LLC. All rights reserved.
//

import UIKit

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    let colors: [UIColor]
    let cellReuseIdentifier: String

    init(colors: [UIColor], cellReuseIdentifier: String) {
        self.colors = colors
        self.cellReuseIdentifier = cellReuseIdentifier
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }
}
