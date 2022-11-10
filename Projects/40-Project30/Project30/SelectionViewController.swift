//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
	var items = [String]() // this is the array that will store the filenames to load
	var dirty = false
    
    // Challenge 3
    var images = [UIImage?]()
    var imagesLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Reactionist"
        
        tableView.rowHeight = 90
        tableView.separatorStyle = .none
        
        // our code
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        DispatchQueue.global().async { [weak self] in
            self?.loadImages()
        }
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if dirty {
			// we've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        
        // Challenge 3
        if !imagesLoaded {
            return 0
        } else {
            return items.count * 10
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // reuse cells instead of creating a new one each time
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // challenge 3
        let index = indexPath.row % items.count
        cell.imageView?.image = images[index]
        let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))

        // give the images a nice shadow to make them look a bit more dramatic
        cell.imageView?.layer.shadowColor = UIColor.black.cgColor
        cell.imageView?.layer.shadowOpacity = 1
        cell.imageView?.layer.shadowRadius = 10
        cell.imageView?.layer.shadowOffset = CGSize.zero
        
        // force round shadow instead of letting iOS having to calculate itself
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath

        // each image stores how often it's been tapped
        let defaults = UserDefaults.standard
        cell.textLabel?.text = "\(defaults.integer(forKey: items[index]))"

        return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ImageViewController()
		vc.image = items[indexPath.row % items.count]
		vc.owner = self

		// mark us as not needing a counter reload when we return
		dirty = false

		navigationController!.pushViewController(vc, animated: true)
	}
    
    // Challenge 3
    func loadImages() {
        // load all the JPEGs into our array
        let fm = FileManager.default
        
        // Challenge 1
        if let resourcePath = Bundle.main.resourcePath {
            if let tempItems = try? fm.contentsOfDirectory(atPath: resourcePath) {
                for item in tempItems {
                    if item.range(of: "Large") != nil {
                        items.append(item)
                        // load from cache
                        if let image = checkCache(name: item) {
                            images.append(image)
                        } else {
                            // create and save to cache
                            images.append(createThumbnail(image: item))
                        }
                    }
                }
            }
        }
        imagesLoaded = true
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    // Challenge 3
    func createThumbnail(image: String) -> UIImage? {
        // find the image for this cell, and load its thumbnail
        let imageRootName = image.replacingOccurrences(of: "Large", with: "Thumb")
        
        // Challenge 1
        guard let path = Bundle.main.path(forResource: imageRootName, ofType: nil) else { return nil }
        guard let original = UIImage(contentsOfFile: path) else { return nil }
        
        // scale down the image
        let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        let renderer = UIGraphicsImageRenderer(size: renderRect.size)
        
        let rounded = renderer.image { ctx in
            ctx.cgContext.addEllipse(in: renderRect)
            ctx.cgContext.clip()
            
            original.draw(in: renderRect)
        }
        
        saveToCache(name: image, image: rounded)
        return rounded
    }
    
    // Challenge 3
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Challenge 3
    func saveToCache(name: String, image: UIImage) {
        let imagePath = getDocumentsDirectory().appendingPathComponent(name)
        if let pngData = image.pngData() {
            try? pngData.write(to: imagePath)
        }
    }
    
    // Challenge 3
    func checkCache(name: String) -> UIImage? {
        let path = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile: path.path)
    }
}
