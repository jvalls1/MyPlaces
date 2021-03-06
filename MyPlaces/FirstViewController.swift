//
//  FirstViewController.swift
//  MyPlaces
//
//  Created by user143153 on 22/9/18.
//  Copyright © 2018 UOC. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController, ManagerPlacesObserver {
    
    let manager : ManagerPlaces =  ManagerPlaces.shared()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager.addObserver(object:self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Número de elementos del manager
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getCount()
    }

    // Number of subsections of List. In our case a value of 1 is returned
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Touch down or selection of an element detetected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        // Implement. Accedemos al Manager Places.
        let wplace = manager.getItemAt(position: indexPath.row)
        let dc:DetailController = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
        dc.place = wplace
        
        // Presentacmos el elemento
        present(dc, animated: true, completion: nil)

    }

    // Return the height of selected cell at certain position.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Return the UITableViewCell that paint the selected cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        cell = UITableViewCell()
        
        let swipeRec = UISwipeGestureRecognizer(target: self, action:#selector(removeRow(recognizer:)))
        swipeRec.direction = . right
        cell.tag = indexPath.item
        cell.addGestureRecognizer(swipeRec)
        
        
        let wt : CGFloat = tableView.bounds.size.width
        let place :  Place = manager.getItemAt(position: indexPath.item)
        
        // Add subviews to a cell
        // UI Label and UIImagView
        
        // Building and setting Label
        var label: UILabel
        label = UILabel (frame: CGRect(x:100,y:25, width:wt, height:40))
        let fuente : UIFont = UIFont(name:"Arial",size:14)!
        label.font = fuente
        label.numberOfLines = 4
        label.text = place.name
        label.sizeToFit()
        
        // Adding subview Label to Cell
        cell.contentView.addSubview(label)
        
        
        // Reading the data from Place.
        
        // Building Image and adding subview to cell
        if place.image_in != nil {
            
            let imageIcon : UIImageView = UIImageView(image:UIImage(data: place.image_in!))
            imageIcon.frame = CGRect(x:10,y:25, width:60, height:45)
            cell.contentView.addSubview(imageIcon)
            
        }
        
        // returning cell
        return cell
        
    }
    
    @objc func removeRow(recognizer: UISwipeGestureRecognizer) {
        let thePlace : Place  = manager.getItemAt(position: recognizer.view!.tag)
        manager.delete(_value:thePlace)
        manager.updateObservers()
    }
    
    func onPlacesChange() {
        let view : UITableView = ((self.view as? UITableView)!)
        view.reloadData()
    }
    
}

