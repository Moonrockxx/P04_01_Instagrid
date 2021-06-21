//
//  ViewController.swift
//  P04_01_Instagrid
//
//  Created by TomF on 16/06/2021.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Enums and variables
    
    enum layoutChoices {
        case firstLayout, secondLayout, thirdLayout
    }
    
    var squareSelected = UIButton()
    var selectedLayoutImage = UIImage(named: "Selected")
    
    // MARK: IBOutlets
    // - Swipe Label
    @IBOutlet weak var swipeLabel: UILabel!
    
    
    // - Grid View
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var gridTopLeft: UIButton!
    @IBOutlet weak var gridTopRight: UIButton!
    @IBOutlet weak var rectangleTop: UIButton!
    @IBOutlet weak var gridBottomLeft: UIButton!
    @IBOutlet weak var gridBottomRight: UIButton!
    @IBOutlet weak var rectangleBottom: UIButton!
    
    // - Choices Layout Buttons
    @IBOutlet weak var firstLayoutButton: UIButton!
    @IBOutlet weak var secondLayoutButton: UIButton!
    @IBOutlet weak var thirdLayoutButton: UIButton!
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        thirdLayoutButton.isSelected = true
    }

    // MARK: IBActions
    // - UI setup when a layout is selected
    @IBAction func selectLayout1(_ sender: Any) {
        gridTopLeft.isHidden = true
        gridTopRight.isHidden = true
        rectangleTop.isHidden = false
        gridBottomLeft.isHidden = false
        gridBottomRight.isHidden = false
        rectangleBottom.isHidden = true
        firstLayoutButton.isSelected = true
        secondLayoutButton.isSelected = false
        thirdLayoutButton.isSelected = false
        firstLayoutButton.setImage(selectedLayoutImage, for: .selected)
        
        // - Only for test, remove before publish
        self.shareAnimation(x: 0, y: 0)
    }
    
    @IBAction func selectLayout2(_ sender: Any) {
        gridTopLeft.isHidden = false
        gridTopRight.isHidden = false
        rectangleTop.isHidden = true
        gridBottomLeft.isHidden = true
        gridBottomRight.isHidden = true
        rectangleBottom.isHidden = false
        firstLayoutButton.isSelected = false
        secondLayoutButton.isSelected = true
        thirdLayoutButton.isSelected = false
        secondLayoutButton.setImage(selectedLayoutImage, for: .selected)
        
        // - Only for test, remove before publish
        self.shareAnimation(x: 0, y: 0)
    }
    
    @IBAction func selectLayout3(_ sender: Any) {
        gridTopLeft.isHidden = false
        gridTopRight.isHidden = false
        rectangleTop.isHidden = true
        gridBottomLeft.isHidden = false
        gridBottomRight.isHidden = false
        rectangleBottom.isHidden = true
        firstLayoutButton.isSelected = false
        secondLayoutButton.isSelected = false
        thirdLayoutButton.isSelected = true
        thirdLayoutButton.setImage(selectedLayoutImage, for: .selected)
        
        // - Only for test, remove before publish
        self.shareAnimation(x: 0, y: 0)
    }
    
    // - Defines the pressed button for select a picture in the user library
    @IBAction func selectSquare(_ sender: UIButton) {
        squareSelected = sender
        selectPictureInLibrary()
    }
    
    // - Defines where the swipe should be done depending on the orientation of the device
    @IBAction func swipeForShareGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .up where UIDevice.current.orientation.isLandscape == false :
            self.shareAnimation(x: 0, y: -700)
            showShareSheet()
        case .left where UIDevice.current.orientation.isLandscape == true :
            self.shareAnimation(x: -700, y: 0)
            showShareSheet()
        default :
            print("wrong direction")
            break
        }
    }
    
    // MARK: Methods
    // - Update the label on the swipe stack view depending on the orientation of the device
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            self.swipeLabel.text = "Swipe left to share"
        } else {
            self.swipeLabel.text = "Swipe up to share"
        }
    }
    
    // - Allows to pick a picture in the user library
    func selectPictureInLibrary() {
        let imagePickerController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerController.sourceType = .photoLibrary
        }
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // - Transform the UIView to a UIImage
    func viewToImage(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: image!.cgImage!)
    }
    
    // - Defines the animation when a swipe is done
    private func shareAnimation(x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.75, animations: {
            self.gridView.transform = CGAffineTransform(translationX: x, y: y)
        })
    }
    
    // - Allows to display the share sheet and share the UIImage
    func showShareSheet() {
        let items = viewToImage(view: gridView)
        let ac = UIActivityViewController(activityItems: [items as Any], applicationActivities: [])
        ac.completionWithItemsHandler = {
            (activityType, completed, _, error) in
            if completed {
                self.shareAnimation(x: 0, y: 0)
            } else {
                self.shareAnimation(x: 0, y: 0)
            }
        }
        present(ac, animated: true)
    }
    
}

// MARK: Extensions
// - Extensions and methods for ImagePickerController
extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            squareSelected.imageView?.contentMode = .scaleAspectFill
            squareSelected.clipsToBounds = false
            squareSelected.setImage(pickedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

