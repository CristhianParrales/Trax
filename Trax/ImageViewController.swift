//
//  ImageViewController.swift
//  Cassini
//
//  Created by Cristhian on 9/9/16.
//  Copyright © 2016 Cassini. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    fileprivate func fetchImage() {
      
        if let url = imageURL {
            print("cargar imagen1")
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                print("cargar imagen2")
                let contentsOfURL = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if url == self.imageURL {
                        if let imageData =  contentsOfURL {
                            print("cargar imagen3")
                            self.image = UIImage(data: imageData)
                        } else {
                            self.spinner.stopAnimating()
                        }
                    } else {
                        print("ignored data returned from url \(url)")
                   }
                }
            }
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.maximumZoomScale = 1.0
            scrollView.minimumZoomScale = 0.03
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    fileprivate var imageView = UIImageView()
   
    fileprivate var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
           // spinner.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)

        // Do any additional setup after loading the view.
    }

  
}
