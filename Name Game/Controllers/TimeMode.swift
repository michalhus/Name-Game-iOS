//
//  TimeMode.swift
//  Name Game
//
//  Created by Michal Hus on 5/18/20.
//  Copyright © 2020 Michal Hus. All rights reserved.
//

import UIKit

class TimeMode: UIViewController {
    
    var cellViewSize: CGFloat?
    var timer:Timer?
    var timeLeft = 60
    
    var trees:[Tree] = []
    var randomTargetIndex: Int = 0
    var score: Int = 0
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)
    
    @IBOutlet weak var targetName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timeTitle: UIBarButtonItem!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        targetName.isHidden = true
        
        Networking.getTrees { (response, error) in
            guard let response = response, error == nil else {
                self.errorAlertMessage(title: "Network Error", message: error ?? "Please Try Again Later")
                return
            }
            self.trees = response
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.randomTarget()
            }
        }
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onTimerFires), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func randomTarget() {
        let randomTarget = Int.random(in: 0 ..< trees.count)
        self.targetName.text = "\(trees[randomTarget].firstName) \(trees[randomTarget].lastName)"
        self.targetName.isHidden = false
        randomTargetIndex = randomTarget
    }
    
    @objc func onTimerFires()
    {
        timeLeft -= 1
        timeTitle.title = "\(timeLeft)s"
        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            self.errorAlertMessage(title: "Game Over!", message: "Scored: \(score)", isGameOver: true)
        }
    }
}

extension TimeMode: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trees.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as! TreeCell
        let tree = trees[(indexPath as NSIndexPath).row]
        cell.downloadImage(from: URL(string: "https:\(tree.headshot.url ?? "")")!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TreeCell
        if ( (indexPath as NSIndexPath).row == randomTargetIndex) {
            
            cell.saveImage()
            score += 1
            
            Networking.getTrees { (response, error) in
                guard let response = response, error == nil else {
                    self.errorAlertMessage(title: "Network Error", message: error ?? "Please Try Again Later")
                    return
                }
                self.trees = response
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.randomTarget()
                }
            }
        } else {
            cell.saveImage(correctGuess: false)
        }
    }
}

extension TimeMode: UICollectionViewDelegateFlowLayout  {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + self.sectionInsets.left + self.sectionInsets.right
        cellViewSize = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: cellViewSize!, height: cellViewSize!)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}
