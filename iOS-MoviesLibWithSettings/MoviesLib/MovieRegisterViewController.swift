//
//  MovieRegisterViewController.swift
//  MoviesLib
//
//  Created by Eric Brito.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit

class MovieRegisterViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var lbCategories: UILabel!
    @IBOutlet weak var tfRating: UITextField!
    @IBOutlet weak var tfDuration: UITextField!
    @IBOutlet weak var tvSummary: UITextView!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var btAddUpdate: UIButton!
    
    // MARK: - Properties
    var movie: Movie!
    var smallImage: UIImage!
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if movie != nil {
            tfTitle.text = movie.title
            tfRating.text = "\(movie.rating)"
            tfDuration.text = movie.duration
            tvSummary.text = movie.summary
            if let image = movie.poster as? UIImage {
                ivPoster.image = image
            }
            
            btAddUpdate.setTitle("Atualizar", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if movie != nil {
            if let categories = movie.categories {
                lbCategories.text = categories.map({($0 as! Category).name!}).joined(separator: " | ")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if movie == nil {
            movie = Movie(context: context)
        }
        let vc = segue.destination as! CategoriesViewController
        vc.movie = movie
    }
    
    // MARK: - IBActions
    @IBAction func close(_ sender: UIButton?) {
        if movie != nil && movie.title == nil {
            context.delete(movie)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPoster(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster?", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addUpdateMovie(_ sender: UIButton) {
        if movie == nil {
            movie = Movie(context: context)
        }
        movie.title = tfTitle.text!
        movie.rating = Double(tfRating.text!)!
        movie.summary = tvSummary.text
        movie.duration = tfDuration.text
        if smallImage != nil {
            movie.poster = smallImage
        }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        close(nil)
    }
}

extension MovieRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        let smallSize = CGSize(width: 300, height: 300)
        
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        ivPoster.image = smallImage
        UIGraphicsEndImageContext()
        
        dismiss(animated: true, completion: nil)
    }
}
