//
//  ViewController.swift
//  BepidModelCanvas
//
//  Created by Vítor Chagas on 03/02/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var blocks: [UICollectionView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.blocks.forEach {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = UIColor(red: 197/255.0, green: 221/255.0, blue: 1, alpha: 1)
        }
        
    }

    //MARK - CollectionView Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let postitCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostitCell", for: indexPath) as! PostitCell
        
        postitCell.titleTextField.text = "title \(indexPath.row)"
        postitCell.backgroundColor = .blue
        
        return postitCell
    }

    //MARK: CollectionView Delegate Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width * 0.85
        return CGSize(width: width, height: width / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let cellWidth = collectionView.frame.width * 0.85
        let cellHeight = cellWidth / 4
        
        let verticalInset = cellHeight * 0.25
        let horizontalInset = cellWidth * 0.25
        
        return UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
    
}

