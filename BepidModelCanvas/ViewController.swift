//
//  ViewController.swift
//  BepidModelCanvas
//
//  Created by Vítor Chagas on 03/02/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //@IBOutlet var views: [BlockView]!
    @IBOutlet var blocks: [UICollectionView]!
    
    var postitQuantity = [Int](repeating: 2, count: 9)
    
    var cellSize: CGSize {
        let width = self.blocks[0].frame.size.width * 0.8
        let height = width / 4
        return CGSize(width: width, height: height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.blocks.forEach {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UINib(nibName: "PostitCell", bundle: nil), forCellWithReuseIdentifier: "PostitCell")
            $0.register(UINib(nibName: "ButtonCell", bundle: nil), forCellWithReuseIdentifier: "ButtonCell")
            $0.backgroundColor = UIColor(red: 197/255.0, green: 221/255.0, blue: 1, alpha: 1)
        }
        /*
        self.views.forEach {
            $0.collectionView = $0.subviews.filter { $0 is UICollectionView}.first as! UICollectionView!
        }
        */
    }

    //MARK: CollectionView Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postitQuantity[collectionView.tag]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Add a plus button at last cell
        if indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 {

            let buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as! ButtonCell

            buttonCell.resizeOutlets()
            buttonCell.onSelection = { self.createNewPostit(at: collectionView) }

            return buttonCell
        }

        let postitCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostitCell", for: indexPath) as! PostitCell
        
        postitCell.resizeOutlets()
        postitCell.titleTextField.text = "title \(indexPath.row)"
        postitCell.backgroundColor = .blue
        
        return postitCell
    }

    //MARK: CollectionView Delegate Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return self.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let verticalInset = self.cellSize.height * 0.15
        let horizontalInset = self.cellSize.width * 0.15
        
        return UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
    
    //MARK: View methods
    
    func createNewPostit(at collectionView: UICollectionView) {
        postitQuantity[collectionView.tag] += 1
        collectionView.reloadData()
    }
    
}

