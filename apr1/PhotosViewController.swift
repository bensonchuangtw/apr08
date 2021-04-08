//
//  PhotosViewController.swift
//  apr1
//
//  Created by Benson on 2021/4/8.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var bodyCollectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private let viewModel: PhotosViewModel = PhotosViewModel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        
        self.bodyCollectionView.delegate = self
        self.bodyCollectionView.dataSource = self
        self.bodyCollectionView.backgroundColor = .clear
        self.bodyCollectionView.isHidden = true
        
        let cellNib = UINib.init(nibName: "PhotoCollectionViewCell", bundle: nil)
        self.bodyCollectionView.register(cellNib, forCellWithReuseIdentifier: PhotoCollectionViewCell.cellReuseID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.loadPhotos { [weak self] (success: Bool) in
            self?.indicator.isHidden = true
            
            if success == true {
                self?.bodyCollectionView.reloadData()
                self?.bodyCollectionView.isHidden = false
            } else {
                let loadPhotosError = UIAlertController.init(title: "Error", message: "Something went wrong", preferredStyle: .alert)
                loadPhotosError.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                self?.present(loadPhotosError, animated: true, completion: nil)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension PhotosViewController: UICollectionViewDataSource {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.getCollectionRows()
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.cellReuseID, for: indexPath)
        
        guard let photoCell = cell as? PhotoCollectionViewCell else {
            return cell
        }
        
        cell.tag = indexPath.row
        
        let (_, idStr, title) = self.viewModel.getPhotoDetail(indexPath)
        photoCell.id.text = idStr
        photoCell.title.text = title
        
        photoCell.imageView.image = nil
        photoCell.indicator.isHidden = false
        self.viewModel.requestPhoto(indexPath, tag: cell.tag) { (tag: Int, image: UIImage?) in
            DispatchQueue.main.async {
                if tag == cell.tag {
                    photoCell.imageView.image = image
                }
                photoCell.indicator.isHidden = true
            }
        }
        
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //do nothing
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 8.0) / 4.0
        return CGSize.init(width: width, height: width)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
