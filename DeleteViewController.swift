//
//  DeleteViewController.swift
//  tvBMC
//
//  Created by Renata Faria on 03/03/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//

import UIKit

class DeleteViewController: UIViewController {
    
    private var postitFocused : PostitCell?

    @IBOutlet weak var lblTitle: UILabel! //bmc or postit
    
    @IBOutlet weak var lblDescription: UITextView!
    
    @IBAction func btnConfirmDelete(_ sender: UIButton) {
        //if delete button was clicked
        postitFocused?.postit.destroy({
            sucess in
            if sucess{
                print("postit deleted")
            }
            else{
                print("postit not deleted")
            }
        })
    }
    
    @IBAction func btnCancelDelete(_ sender: UIButton) {
        //just dismiss the screen if cancel was clicked
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
         print("dismiss")
    }
    
    func getSelected(postitFocused : PostitCell){
        self.postitFocused = postitFocused
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("postit selected: \(postitFocused)")
        //compare if is postit or bmc and change title and description (TODO)
        self.lblTitle.text = "Delete post-it"
        self.lblDescription.text = "If you delete it, all data will be deleted too. Are you sure you want to delete this Post-it?"
        
    }

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
