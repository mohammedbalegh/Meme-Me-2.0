//
//  MemeTableViewVC.swift
//  Temp
//
//  Created by mohammed balegh on 5/4/20.
//  Copyright © 2020 mohammed balegh. All rights reserved.
//

import UIKit

class MemeTableViewVC: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    var  memes: [Meme]! {
        let object = UIApplication.shared.delegate as! AppDelegate
        return object.memes
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableViewCell") as! MemeMeTableViewCell
        
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.cellImage.image = meme.memedImage
        cell.cellTopLabel.text = meme.top
        cell.cellBottomLabel.text = meme.bottom
        cell.cellMaimLabel.text = meme.top + ".." + meme.bottom
        
        cell.cellTopLabel.makeOutLine(oulineColor: .black, foregroundColor: .white)
        cell.cellBottomLabel
            .makeOutLine(oulineColor: .black, foregroundColor: .white)
        
        // If the cell has a detail label, we will put the evil scheme in.
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentMeme = self.memes[(indexPath as NSIndexPath).row]
        performSegue(withIdentifier: "MemeDetailsViewController", sender: currentMeme)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "MemeDetailsViewController" {
                if let destinationVC = segue.destination as? MemeDetailsViewController {
                    destinationVC.meme = sender as? Meme

                }
            }
        }
    }
    


extension UILabel{

    func makeOutLine(oulineColor: UIColor, foregroundColor: UIColor) {
    let strokeTextAttributes = [
        NSAttributedString.Key.strokeColor : oulineColor,
        NSAttributedString.Key.foregroundColor : foregroundColor,
        NSAttributedString.Key.strokeWidth : -4.0,
        NSAttributedString.Key.font : UIFont(name: "Impact", size: 17)!
        ] as [NSAttributedString.Key : Any]
    self.attributedText = NSMutableAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
    }
}

