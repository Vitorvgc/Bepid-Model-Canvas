//
//  ViewController.swift
//  BepidModelCanvas
//
//  Created by Vítor Chagas on 03/02/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        CloukKitHelper.getAllRecords(fromEntity: "bmc", competionHandler: {
            sucess, records in
            if sucess{
                if let recs = records{
                    print("bmc count \(recs.count)")
                    for rec in recs{
                        let bmc = CWBusinessModelCanvas.init(withRecord: rec)
                        print("title: \(bmc.title) key: \(bmc.recordId)")
                        CloukKitHelper.getAllChildren(fromRecordID: rec.recordID, childEntity: "block", competionHandler: {
                            sucess, records in
                            if sucess{
                                print("blocks count: \(records?.count)")
                                for blockRec in records!{
                                    print("block title: \(blockRec["title"])")
                                    CloukKitHelper.getAllChildren(fromRecordID: blockRec.recordID, childEntity: "postit", competionHandler: {
                                        sucess, records in
                                        if sucess{
                                            print("block title: \(blockRec["title"])")
                                            print("posit count \(records?.count)")
                                        }
                                    })
                                }
                            }
                        })
                        
                    }
                }
                else{
                    print(" bmc doesnt exist!")
                }
            }
        })
        
//        CWBusinessModelCanvas.createBmc(withTitle: "bmc TV", competionHandler: {
//            sucess, bmc in
//            if sucess {
//                print("bmc salvo com sucesso.")
//                if let bmcCreated = bmc{
//                    CWBusinessModelCanvas.saveBlocks(blocks: bmcCreated.blocks, competionHandler:
//                        {sucess, record in
//                            if sucess{
//                                CWPostit.createPostit(withTitle: "positTv", andText: "posit from tv", andColor: UIColor.blue, parent: bmcCreated.blocks[0].record, competionHandler: {
//                                    sucess, positRecord in
//                                    if sucess{
//                                        print("posit  salvo")
//                                    }
//                                    else{
//                                        print("falha ao salvar posit")
//                                    }
//                                })
//                            }
//                            
//                    })
//                }
//            }
//            else{
//                print("falha ao salvar bmc")
//            }
//        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

