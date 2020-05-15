//
//  MemeCollectionViewController.swift
//  Temp
//
//  Created by mohammed balegh on 5/7/20.
//  Copyright © 2020 mohammed balegh. All rights reserved.
//
//
//  MemeCollectionViewController.swift
//  Temp
//
//  Created by mohammed balegh on 5/4/20.
//  Copyright © 2020 mohammed balegh. All rights reserved.
//

import UIKit

private let reuseIdentifier = "memeCollectionViewCell"

class MemeCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    var  memes: [Meme]! {
        let object = UIApplication.shared.delegate as! AppDelegate
        return object.memes
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let space:CGFloat = 3.0
        let widthDimensiion = (view.frame.size.width - (2 * space)) / space
        let heightDimensiion = (view.frame.size.height - (2 * space)) / space
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: widthDimensiion, height: heightDimensiion)
        self.collectionView.reloadData()
    }

     override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(memes.count)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.memeImage.image = meme.image
        cell.bottomLabel.text = meme.bottom
        cell.topLabel.text = meme.top
        
        cell.bottomLabel.makeOutLine(oulineColor: .black, foregroundColor: .white)
        cell.topLabel
            .makeOutLine(oulineColor: .black, foregroundColor: .white)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
