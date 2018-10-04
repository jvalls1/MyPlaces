//
//  FirstViewController.swift
//  MyPlaces
//
//  Created by user143153 on 22/9/18.
//  Copyright © 2018 UOC. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Número de elementos del manager
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // Number of subsections of List. In our case a value of 1 is returned
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Touch down or selection of an element detetected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }

    // Return the height of selected cell at certain position.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Return the UITableViewCell that paint the selected cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        cell = UITableViewCell()
        
        let wt : CGFloat = tableView.bounds.size.width
        
        // Add subviews to a cell
        // UI Label and UIImagView
        
        // Building and setting Label
        var label: UILabel
        label = UILabel (frame: CGRect(x:100,y:25, width:wt, height:40))
        let fuente : UIFont = UIFont(name:"Arial",size:12)!
        label.font = fuente
        label.numberOfLines = 4
        label.text = "COSMO"
        label.sizeToFit()
        
        // Adding subview Label to Cell
        cell.contentView.addSubview(label)
        
        // Building Image and adding subview to cell
        let imageIcon : UIImageView = UIImageView(image: UIImage(named:"cosmo.jpg"))
        imageIcon.frame = CGRect(x:10,y:50, width:50, height:50)
        cell.contentView.addSubview(imageIcon)
        
        // returning cell
        return cell
        
    }
    
    
    
}

