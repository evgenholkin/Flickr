//
//  ViewController.swift
//  Flickr
//
//  Created by Евгений Холкин on 06.06.2020.
//  Copyright © 2020 Евгений Холкин. All rights reserved.
//

import UIKit
import Nuke

class MainViewController: UIViewController {
    
//MARK: - Properties
    
    private let service = NetworkService()
    private var photosArray: [Items] = []
    var tag = ""
    
//MARK: - Outlets
    
    @IBOutlet weak var fullPhotoView: UIImageView!
    @IBOutlet weak var closePhoto: UIButton!
    @IBAction func closePhoto(_ sender: Any) {
        UIView.animate(withDuration: 1) {
            self.collectionView.alpha = 1
        }
    }
    
    var dateInfo = ""
    var dateInfo2 = ""
    var tags = ""
    @IBOutlet weak var infoButton: UIButton!
    @IBAction func infoButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "InfoScreen") as! InfoViewController
        vc.publishDateInfo = self.dateInfo
        vc.takenDateInfo = self.dateInfo2
        vc.tags = self.tags
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func settingsButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsScreen") as! SettingsViewController
        vc.delegate = self
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
//MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegateOtherControllers()
        configureOutletsStyle()
        configureUI()
        getData()
        sorting()
        
    }
    
//MARK: - Methods
    
    private func delegateOtherControllers() {
        let vc = SettingsViewController()
        vc.delegate = self
    }
    
    private func configureUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func getData() {
        service.getData(tag) { [weak self] (photo)  in
            guard let photos = photo else {
                return
            }
            self?.photosArray = photos
            self?.sorting()
        }
    }
    
    private func sorting() {

        if UserDefaults.standard.integer(forKey: "Sorting") == 0 {
            //sorting by name
            self.photosArray.sort(by: { $0.title! < $1.title! } )
        } else if UserDefaults.standard.integer(forKey: "Sorting") == 1 {
            //sorting by taken date
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            self.photosArray.sort(by: {
                df.date(from: $0.date_taken!)!.compare( df.date(from: $1.date_taken!)! ) == .orderedDescending
            })
        }
        
        self.collectionView.reloadData()
    }
    
    private func configureOutletsStyle() {
        closePhoto.layer.masksToBounds = true
        closePhoto.layer.shadowOffset = CGSize(width: 0, height: 0)
        closePhoto.layer.shadowColor = UIColor.white.cgColor
        closePhoto.layer.shadowRadius = 3
        closePhoto.layer.shadowOpacity = 1
        infoButton.layer.masksToBounds = true
        infoButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        infoButton.layer.shadowColor = UIColor.white.cgColor
        infoButton.layer.shadowRadius = 3
        infoButton.layer.shadowOpacity = 1
    }
}
    
//MARK: - Extensions
    
extension MainViewController: UICollectionViewDelegate {

}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell",
                                                 for: indexPath) as? PhotoCell
        cell?.configure(items: photosArray[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView = UICollectionReusableView()
        
        if kind == UICollectionView.elementKindSectionHeader {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchBar", for: indexPath)
        }
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.dateInfo = photosArray[indexPath.row].published ?? "No date"
        self.dateInfo2 = photosArray[indexPath.row].date_taken ?? "No date"
        self.tags = photosArray[indexPath.row].tags ?? ""
        
        view.backgroundColor = .darkGray
        UIView.animate(withDuration: 1) {
            self.collectionView.alpha = 0
        }
        guard let photoUrlString = photosArray[indexPath.row].media?.m else {
            return
        }
        guard let photoUrl = URL(string: photoUrlString) else {
            return
        }
        Nuke.loadImage(with: photoUrl, into: fullPhotoView)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfColumns: CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets: CGFloat = 0
        let cellSpacing: CGFloat = 5
        
        return CGSize(width: (width / numberOfColumns) - (xInsets + cellSpacing), height: (width / numberOfColumns) - (xInsets + cellSpacing))
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tag = searchBar.text ?? ""
        getData()
    }
}

extension MainViewController: SettingsViewDelegate {
    func refreshData() {
        sorting()
    }
}

extension MainViewController : UIViewControllerTransitioningDelegate {
    
    class SizePresentationController : UIPresentationController {
        override var frameOfPresentedViewInContainerView: CGRect {
            return CGRect(x: 0,
                          y: (containerView!.bounds.height - containerView!.bounds.height/3),
                          width: containerView!.bounds.width,
                          height: containerView!.bounds.height/3)
        }
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SizePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}






