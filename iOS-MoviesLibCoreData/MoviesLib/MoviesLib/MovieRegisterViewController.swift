//
//  MovieRegisterViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 13/09/17.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit

class MovieRegisterViewController: UIViewController {
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var lbCategories: UILabel!
    @IBOutlet weak var tfRating: UITextField!
    @IBOutlet weak var tfDuration: UITextField!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var tvSummary: UITextView!
    @IBOutlet weak var btAddUpdate: UIButton!
    
    var movie: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if movie != nil {
            tfTitle.text = movie.title
            tfRating.text = "\(movie.rating)"
            tfDuration.text = movie.duration
            tvSummary.text = movie.summary
            btAddUpdate.setTitle("Atualizar", for: UIControlState.normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func addUpdateMovie(_ sender: UIButton) {
        if movie == nil { movie = Movie(context: self.context) }
        
        movie.title = tfTitle.text
        movie.rating = Double(tfRating.text!)!
        movie.duration = tfDuration.text
        movie.summary = tvSummary.text
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
        close(nil)
    }
    
    @IBAction func close(_ sender: UIButton?) {
        dismiss(animated: true, completion: nil)
    }

}
