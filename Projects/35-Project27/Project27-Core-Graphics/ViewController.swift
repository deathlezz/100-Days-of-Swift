//
//  ViewController.swift
//  Project27-Core-Graphics
//
//  Created by deathlezz on 20/10/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        drawRectangle()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawEmoji()
        case 7:
            drawTWIN()
        default:
            break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            // awesome drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            // awesome drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            // awesome drawing code
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0..<8 {
                for column in 0..<8 {
                    if (row + column).isMultiple(of: 2) {
                        ctx.cgContext.fill(CGRect(x: column * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = image
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            // awesome drawing code
            ctx.cgContext.translateBy(x: 256, y: 256)
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0...rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            // awesome drawing code
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var lenght: CGFloat = 256
            
            for _ in 0..<256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: lenght, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: lenght, y: 50))
                }
                
                lenght *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            // awesome drawing code
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        imageView.image = image
    }
    
    // Challenge 1
    func drawEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            // awesome drawing code
            let head = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 10, dy: 10)
            ctx.cgContext.setFillColor(UIColor.systemYellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.systemOrange.cgColor)
            ctx.cgContext.setLineWidth(20)
            ctx.cgContext.addEllipse(in: head)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            let leftEye = CGRect(x: 150, y: 160, width: 65, height: 80).insetBy(dx: 5, dy: 5)
            let rightEye = CGRect(x: 300, y: 160, width: 65, height: 80).insetBy(dx: 5, dy: 5)
            let mouth = CGRect(x: 198, y: 305, width: 120, height: 120).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.brown.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(5)
            ctx.cgContext.addEllipse(in: leftEye)
            ctx.cgContext.addEllipse(in: rightEye)
            ctx.cgContext.addEllipse(in: mouth)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    // Challenge 2
    func drawTWIN() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            drawT(ctx: ctx.cgContext)
            drawW(ctx: ctx.cgContext)
            drawI(ctx: ctx.cgContext)
            drawN(ctx: ctx.cgContext)
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.setLineJoin(.round)
            ctx.cgContext.setLineCap(.round)
            ctx.cgContext.drawPath(using: .stroke)
        }
        
        imageView.image = image
    }
    
    func drawT(ctx: CGContext) {
        ctx.move(to: CGPoint(x: 121, y: 350))
        ctx.addLine(to: CGPoint(x: 121, y: 200))
        ctx.move(to: CGPoint(x: 81, y: 200))
        ctx.addLine(to: CGPoint(x: 161, y: 200))
    }
    
    func drawW(ctx: CGContext) {
        ctx.move(to: CGPoint(x: 191, y: 200))
        ctx.addLine(to: CGPoint(x: 221, y: 350))
        ctx.addLine(to: CGPoint(x: 251, y: 200))
        ctx.addLine(to: CGPoint(x: 281, y: 350))
        ctx.addLine(to: CGPoint(x: 311, y: 200))
    }
    
    func drawI(ctx: CGContext) {
        ctx.move(to: CGPoint(x: 341, y: 350))
        ctx.addLine(to: CGPoint(x: 341, y: 200))
    }
    
    func drawN(ctx: CGContext) {
        ctx.move(to: CGPoint(x: 371, y: 350))
        ctx.addLine(to: CGPoint(x: 371, y: 200))
        ctx.addLine(to: CGPoint(x: 431, y: 350))
        ctx.addLine(to: CGPoint(x: 431, y: 200))
    }
    
}

