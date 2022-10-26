# Core Graphics Redux

## This playground lets us walk through a variety of Core Graphics techniques.

### 1.Rectangles

#### When you run the code below, it will create a 1000x1000 image with a 600x600 blue box in its center, then display it in the image view you'll see in the playground live view.

> Can you write some code to draw a red box on top of the blue one, making it 200x200 and centered like the blue one?

    import UIKit

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let renderer = UIGraphicsImageRenderer(bounds: rect)

    let rendered = renderer.image { ctx in
        UIColor.blue.setFill()
        ctx.cgContext.fill(CGRect(x: 200, y: 200, width: 600, height: 600))

        // Add your code here
        UIColor.red.setFill()
        ctx.cgContext.fill(CGRect(x: 400, y: 0, width: 200, height: 200))
    }

    showOutput(rendered)

### 2.Stripes

#### This time you'll see the image now contains five rectangles, each 200 pixels wide and the full height of the image. Your designer wanted to make them red, orange, yellow, green, and blue, but they didn't get some of the colors quite right they look faded.

> Can you draw the five rectangles in their correct colors? The first one has been done for you.

    import UIKit

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let renderer = UIGraphicsImageRenderer(bounds: rect)

    let rendered = renderer.image { ctx in
        UIColor.red.setFill()
        ctx.cgContext.fill(CGRect(x: 0, y: 0, width: 200, height: 1000))

        // Add your code here
        UIColor.orange.setFill()
        ctx.cgContext.fill(CGRect(x: 200, y: 0, width: 200, height: 1000))
        UIColor.yellow.setFill()
        ctx.cgContext.fill(CGRect(x: 400, y: 0, width: 200, height: 1000))
        UIColor.green.setFill()
        ctx.cgContext.fill(CGRect(x: 600, y: 0, width: 200, height: 1000))
        UIColor.blue.setFill()
        ctx.cgContext.fill(CGRect(x: 800, y: 0, width: 200, height: 1000))
    }

    showOutput(rendered)

### 3.Flags

#### Impressed with your rectangle drawing prowess, your designer has returned to ask for help in designing a flag for the United Republic of Swiftovia. The client asked for a solid background color with a nice and bright cross over it, but they didn't like the colors chosen by your designer.

> Recreate your designer's image, but this time using a yellow background and an orange cross. Your designer suggested a couple of lines for you, which should give you a headstart.

    import UIKit

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let renderer = UIGraphicsImageRenderer(bounds: rect)

    let rendered = renderer.image { ctx in
        // "I think these two look better!" - Designer
        UIColor.yellow.setFill()
        ctx.cgContext.fill(CGRect(x: 0, y: 0, width: 1000, height: 1000))
        
        UIColor.orange.setFill()
        ctx.cgContext.fill(CGRect(x: 0, y: 400, width: 1000, height: 200))
        ctx.cgContext.fill(CGRect(x: 400, y: 0, width: 200, height: 1000))
    }

    showOutput(rendered)

### 4.Checkerboards

#### Drawing rectangles inside two loops lets us create a checkerboard pattern. The image already has a white background color, so we need to draw black rectangles in an odd-even pattern to get the desired result.

> The code below makes a checkerboard, but it doesn't fill the image correctly. Try adjusting the grid size, number of rows, and number of columns so that you get a 10x10 checkerboard across the entire image.

    import UIKit

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let renderer = UIGraphicsImageRenderer(bounds: rect)

    let rendered = renderer.image { ctx in
        UIColor.black.setFill()

        let size = 100

        for row in 0 ..< 10 {
            for col in 0 ..< 10 {
                if (row + col) % 2 == 0 {
                    ctx.cgContext.fill(CGRect(x: col * size, y: row * size, width: size, height: size))
                }
            }
        }
    }

    showOutput(rendered)

### 5.Ellipses

#### Now that you've mastered rectangles, ellipses ought to be easy. Like rectangles, ellipses are drawn by activating a color then specifying a rectangle. If the rectangle has the same width and height you'll get a circle, otherwise you'll get an ellipse.

> The code below draws one red circle in the top-left corner, but your designer wants you to create three more: a yellow circle in the top-right corner, a blue circle in the bottom-left corner, and a green circle in the bottom-right corner.

    import UIKit

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let renderer = UIGraphicsImageRenderer(bounds: rect)

    let rendered = renderer.image { ctx in
        UIColor.red.setFill()
        let circle1 = CGRect(x: 0, y: 0, width: 500, height: 500)
        ctx.cgContext.fillEllipse(in: circle1)

        // Add your code here
        UIColor.yellow.setFill()
        let circle2 = CGRect(x: 500, y: 0, width: 500, height: 500)
        ctx.cgContext.fillEllipse(in: circle2)
        
        UIColor.blue.setFill()
        let circle3 = CGRect(x: 0, y: 500, width: 500, height: 500)
        ctx.cgContext.fillEllipse(in: circle3)
        
        UIColor.green.setFill()
        let circle4 = CGRect(x: 500, y: 500, width: 500, height: 500)
        ctx.cgContext.fillEllipse(in: circle4)
    }

    showOutput(rendered)

### 6.Flowers

#### You have a new client! A local artisanal bakery always adds a finishing touch to its loaves by sprinkling poppy seeds on top, and they want you to make them a great poppy logo. Your designer has already sketched something, but it falls to you to figure out how to make it happen in code.

> Your designer has provided a sketch of what they want: four red circles, with a black circle in the middle. Can you make this happen using ellipses? They've drawn the first one for you, but it isn't quite right.

    import UIKit

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let renderer = UIGraphicsImageRenderer(bounds: rect)

    let rendered = renderer.image { ctx in
    	// "This doesn't seem right…" – Designer
        UIColor.red.setFill()
        let circle1 = CGRect(x: 100, y: 100, width: 500, height: 500)
        ctx.cgContext.fillEllipse(in: circle1)
        
        let circle2 = CGRect(x: 400, y: 100, width: 500, height: 500)
        ctx.cgContext.fillEllipse(in: circle2)
        
        let circle3 = CGRect(x: 100, y: 400, width: 500, height: 500)
        ctx.cgContext.fillEllipse(in: circle3)
        
        let circle4 = CGRect(x: 400, y: 400, width: 500, height: 500)
        ctx.cgContext.fillEllipse(in: circle4)
        
        UIColor.black.setFill()
        let circle5 = CGRect(x: 400, y: 400, width: 200, height: 200)
        ctx.cgContext.fillEllipse(in: circle5)
    }

    showOutput(rendered)

### 7.Strokes

#### Core Graphics lets us control how things are drawn: do we want to fill the shape, stroke the outline of the shape, or both? When you're stroking the outline, you can also adjust the line width to make the stroke thicker or thinner.

#### So far we've been using fill() and fillEllipse() to draw shapes, but when you want to fill and stroke you should use addRect() and addEllipse(). These don't draw anything, but instead just create a path that you can then fill and/or stroke using drawPath().

#### Your designer has sketched out the icon for a new app: one 400x400 circle in the middle, and four 200x200 circles on its top, bottom, left, and right edges. Although a 40-point line width looks good on the big circle, they think something like 10 points for the smaller circles might look better.

> Can you recreate their logo sketch using ellipses, strokes, and fills? They already added the first circle for you, which should give you a nice template for the others.

    import UIKit

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let renderer = UIGraphicsImageRenderer(bounds: rect)

    let rendered = renderer.image { ctx in
        UIColor.red.setFill()
        UIColor.black.setStroke()
        ctx.cgContext.setLineWidth(40)

        let bigCircle = CGRect(x: 300, y: 300, width: 400, height: 400)
        ctx.cgContext.addEllipse(in: bigCircle)
        ctx.cgContext.drawPath(using: .fillStroke)

        // Add your code here
        ctx.cgContext.setLineWidth(10)
        let circle1 = CGRect(x: 400, y: 100, width: 200, height: 200)
        ctx.cgContext.addEllipse(in: circle1)
        ctx.cgContext.drawPath(using: .fillStroke)
        
        let circle2 = CGRect(x: 700, y: 400, width: 200, height: 200)
        ctx.cgContext.addEllipse(in: circle2)
        ctx.cgContext.drawPath(using: .fillStroke)
        
        let circle3 = CGRect(x: 100, y: 400, width: 200, height: 200)
        ctx.cgContext.addEllipse(in: circle3)
        ctx.cgContext.drawPath(using: .fillStroke)
        
        let circle4 = CGRect(x: 400, y: 700, width: 200, height: 200)
        ctx.cgContext.addEllipse(in: circle4)
        ctx.cgContext.drawPath(using: .fillStroke)
    }

    showOutput(rendered)

### 7.Rainbows

#### Your boss has dug out some old code that was supposed to draw a rainbow by stroking the outlines of concentric circles. Sadly, it looks like the data got corrupted somehow, because three of its values don't seem right.

> Your designer has produced a sketch showing how it should look. Can you adjust the code to help make it work correctly?

    import UIKit

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let renderer = UIGraphicsImageRenderer(bounds: rect)

    let rendered = renderer.image { ctx in
        ctx.cgContext.setLineWidth(50)

        let colors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple]
        var xPos = 0
        var yPos = 500
        var size = 1000

        for color in colors {
            // "These three values got corrupted!" – Boss
            xPos += 50
            yPos += 50
            size -= 100

            let rect = CGRect(x: xPos, y: yPos, width: size, height: size)
            color.setStroke()
            ctx.cgContext.strokeEllipse(in: rect)
        }
    }

    showOutput(rendered)

### 8.Emoji

#### It's time for the ultimate test of your circle-drawing ability: can you draw emoji? Your CEO wants to pitch a new design for Apple to use in iOS, but to win the contract you'll need to convert your designer's sketch into Core Graphics code using ellipses, strokes, and fills.

> Try to recreate your designer's sketch using four circles. The face should be colored yellow, the mouth brown, and both eyes black. Your designer has helped write the code for the face, but it isn't quite right.

    import UIKit

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let renderer = UIGraphicsImageRenderer(bounds: rect)

    let rendered = renderer.image { ctx in
        UIColor.black.setStroke()
        UIColor.yellow.setFill()
        ctx.cgContext.setLineWidth(10)

        let face = CGRect(x: 100, y: 100, width: 800, height: 800)
        ctx.cgContext.addEllipse(in: face)
        ctx.cgContext.drawPath(using: .fillStroke)
        
        UIColor.brown.setFill()
        let mouth = CGRect(x: 350, y: 500, width: 300, height: 300)
        ctx.cgContext.addEllipse(in: mouth)
        ctx.cgContext.drawPath(using: .fillStroke)
        
        UIColor.black.setStroke()
        UIColor.black.setFill()
        ctx.cgContext.setLineWidth(10)
        
        let leftEye = CGRect(x: 250, y: 300, width: 150, height: 150)
        ctx.cgContext.addEllipse(in: leftEye)
        ctx.cgContext.drawPath(using: .fillStroke)
        
        let rightEye = CGRect(x: 600, y: 300, width: 150, height: 150)
        ctx.cgContext.addEllipse(in: rightEye)
        ctx.cgContext.drawPath(using: .fillStroke)
    }

    showOutput(rendered)

### 9.Text

#### If you have an NSAttributedString, you can render it directly to a Core Graphics context just by saying where it should be drawn. All the string's attributes will be used for rendering, including its font, size, color, and more.

> Someone has been putting up inspirational posters around your office, saying "The early bird catches the worm." Your designer wants your help to design a modified version that says "But the second mouse gets the cheese" in red text 100 pixels below. Can you write code to match their sketch?

    import UIKit

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let renderer = UIGraphicsImageRenderer(bounds: rect)

    let rendered = renderer.image { ctx in
        let firstPosition = rect.offsetBy(dx: 0, dy: 300)
        let firstText = "The early bird catches the worm."
        let firstAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 72),
            .foregroundColor: UIColor.blue
        ]

        let firstString = NSAttributedString(string: firstText, attributes: firstAttrs)
        firstString.draw(in: firstPosition)

        // Add your code here
        let secondPosition = rect.offsetBy(dx: 0, dy: 400)
        let secondText = "But the second mouse gets the cheese"
        let secondAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 72),
            .foregroundColor: UIColor.red
        ]
        
        let secondString = NSAttributedString(string: secondText, attributes: secondAttrs)
        secondString.draw(in: secondPosition)
    }

    showOutput(rendered)

### 10.Lines

#### It's approaching Burns Night, the one day of the year where everyone asks "so, what exactly is haggis?" Your team needs to design some suitably Scottish graphics to place around your office, and you've decided to draw a saltire –the Scottish flag. This is a diagonal white cross on a blue background.

#### Fortunately for you, Core Graphics is able to draw lines out of the box: pass a CGPoint to the move(to:) method, then another to addLine(to:) to build a path. Add and move as many times as you need, before finally calling strokePath() to render it all. As this is a stroke action, you can adjust the width of your line by calling setLineWidth() beforehand.

> Your team tried to write code to draw the flag, but only managed one arm of the cross and even then it's far too small – it needs to stretch from corner to corner, and have another arm going in the other direction. Your designer also thinks a 10-pixel width is too small, and suggests trying 100 instead. Can you use Core Graphics to draw a good-looking Scottish flag like the one below?

    import UIKit

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let renderer = UIGraphicsImageRenderer(bounds: rect)

    let rendered = renderer.image { ctx in
        UIColor(red: 0, green: 0.37, blue: 0.72, alpha: 1).setFill()
        ctx.cgContext.fill(rect)
        UIColor.white.setStroke()

        ctx.cgContext.setLineWidth(100)

        ctx.cgContext.move(to: CGPoint(x: 0, y: 0))
        ctx.cgContext.addLine(to: CGPoint(x: 1000, y: 1000))
        
        ctx.cgContext.move(to: CGPoint(x: 0, y: 1000))
        ctx.cgContext.addLine(to: CGPoint(x: 1000, y: 0))

        ctx.cgContext.strokePath()
    }

    showOutput(rendered)

### 11.Images

#### If you have a UIImage, you can render it directly into a Core Graphics context at any size you want – it will automatically be scaled up or down as needed. To do this, just call draw(in:) on your image, passing in the CGRect where it should be drawn.

> Your designer wants you to create a picture frame effect for an image. He's placed the frame at the right size, but it's down to you to position it correctly then position and size the image inside it.

    import UIKit

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let renderer = UIGraphicsImageRenderer(bounds: rect)

    let mascot = UIImage(named: "HackingWithSwiftMascot.jpg")

    let rendered = renderer.image { ctx in
        // "I can't get this right!" – Designer
         UIColor.darkGray.setFill()
         ctx.cgContext.fill(rect)

         UIColor.black.setFill()
         let borderRect = CGRect(x: 200, y: 200, width: 640, height: 640)
         ctx.cgContext.fill(borderRect)

         let imageRect = CGRect(x: 250, y: 250, width: 540, height: 540)
         mascot?.draw(in: imageRect)
    }

    showOutput(rendered)

### 12.Translation

#### By default, Core Graphics considers X:0 Y:0 to be the top-left corner of your canvas, but you can move that by calling the translateBy() method. For example, calling translateBy(x: 500, y: 500) will move the center point of your context to the middle of our 1000x1000 image.

#### If we draw the same circle several times, each time translating the origin of our Core Graphics context, we'll actually draw multiple circles across the screen because each one will start at a different location.

> One of your teammates has tried to reproduce a design that places circles across the screen, but they aren't having much luck. Can you adjust their code so that the seven circles are positioned and sized correctly?

    import UIKit

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let renderer = UIGraphicsImageRenderer(bounds: rect)

    let rendered = renderer.image { ctx in
        let ellipseRectangle = CGRect(x: 0, y: 300, width: 400, height: 400)
        ctx.cgContext.setLineWidth(8)
        UIColor.red.setStroke()

        for _ in 1...7 {
            ctx.cgContext.strokeEllipse(in: ellipseRectangle)
            ctx.cgContext.translateBy(x: 100, y: 0)
        }
    }

    showOutput(rendered)

### 13.Rotation

#### Your designer is very pleased this morning, because they've designed a neat geometric shape for a client logo. It might look complicated, but really it's just eight squares with each one rotated by 45 degrees around its bottom-left corner.

#### Your designer tried writing the Core Graphics code themselves, but things aren't going to plan: they don't have enough boxes, and the ones they do have are all being drawn in the top-left corner.

#### Part of the problem is that Core Graphics measures angles in radians: if you rotate by .pi radians it's the same as rotating 180 degrees, and if you rotate .pi / 4 radians it's the same as rotating 45 degrees.

> Can you fix this code so that it draws the designer's sketch as they want? You might want to start by adjusting the translateBy() call.

    import UIKit

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let renderer = UIGraphicsImageRenderer(bounds: rect)

    let boxRectangle = CGRect(x: 0, y: 0, width: 300, height: 300)

    let rendered = renderer.image { ctx in
        ctx.cgContext.setLineWidth(8)
        ctx.cgContext.translateBy(x: 500, y: 500)

        for _ in 1...8 {
            ctx.cgContext.addRect(boxRectangle)
            ctx.cgContext.rotate(by: .pi / 4)
        }

        UIColor.red.setStroke()
        ctx.cgContext.strokePath()
    }

    showOutput(rendered)

### 14.Blending

#### All the drawing operations you've used so far come with a hidden superpower: you can blend them together. This means that when you draw an ellipse over some existing color you can specify how the drawing should take place – should the new color just overwrite the old one, or should they be combined together somehow?

#### The easiest way to see how this works is to try it for yourself. So, below is some code that renders four overlapping red circles – try running it now. You'll notice code to adjust the blend mode is commented out, so try uncommenting it then running the code again.

#### That commented line is an XOR, which means this: "if the source pixel has a color and the destination doesn't, use the source; if the destination pixel has a color and the source doesn't, use the destination; if they both have colors, draw nothing." It's a pretty neat end result for such little work!

> Try some alternative blend modes to see what you can come up with – it's common to use .multiply to make one color to darken another, for example.

    import UIKit

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let renderer = UIGraphicsImageRenderer(bounds: rect)

    let rendered = renderer.image { ctx in
        ctx.cgContext.setBlendMode(.xor)

        UIColor.red.setFill()
        ctx.cgContext.fillEllipse(in: CGRect(x: 200, y: 200, width: 400, height: 400))
        ctx.cgContext.fillEllipse(in: CGRect(x: 400, y: 200, width: 400, height: 400))
        ctx.cgContext.fillEllipse(in: CGRect(x: 400, y: 400, width: 400, height: 400))
        ctx.cgContext.fillEllipse(in: CGRect(x: 200, y: 400, width: 400, height: 400))
    }

    showOutput(rendered)

### 15.Sandbox

#### Sandbox - noun: a place where people can play. (In the sand.)

> Below are some example Core Graphics instructions based on things you've learned in this playground. This is a great place to experiment by copying, pasting, and experimenting until you get the result you want – enjoy!

    import UIKit

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let renderer = UIGraphicsImageRenderer(bounds: rect)

    let rendered = renderer.image { ctx in
        // draw a green box
        UIColor.green.setFill()
        UIColor.black.setStroke()
        ctx.cgContext.setLineWidth(10)
        ctx.cgContext.addRect(CGRect(x: 50, y: 500, width: 150, height: 150))
        ctx.cgContext.drawPath(using: .fillStroke)

        // draw a zig zag line
        ctx.cgContext.move(to: CGPoint(x: 50, y: 300))
        ctx.cgContext.addLine(to: CGPoint(x: 100, y: 350))
        ctx.cgContext.addLine(to: CGPoint(x: 150, y: 300))
        ctx.cgContext.addLine(to: CGPoint(x: 200, y: 350))
        ctx.cgContext.addLine(to: CGPoint(x: 250, y: 300))
        ctx.cgContext.addLine(to: CGPoint(x: 300, y: 350))
        ctx.cgContext.addLine(to: CGPoint(x: 350, y: 300))
        ctx.cgContext.addLine(to: CGPoint(x: 400, y: 350))
        ctx.cgContext.addLine(to: CGPoint(x: 450, y: 300))
        ctx.cgContext.setLineWidth(20)
        ctx.cgContext.strokePath()

        // draw a quote
        let text = "Here's to the crazy ones"
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 72),
            .foregroundColor: UIColor.blue
        ]

        let string = NSAttributedString(string: text, attributes: attrs)
        string.draw(in: rect)

        // draw overlapping circles
        UIColor.red.setFill()
        ctx.cgContext.setBlendMode(.xor)
        ctx.cgContext.fillEllipse(in: CGRect(x: 700, y: 400, width: 200, height: 200))
        ctx.cgContext.fillEllipse(in: CGRect(x: 600, y: 400, width: 200, height: 200))
        ctx.cgContext.setBlendMode(.normal)

        // draw an image
        ctx.cgContext.rotate(by: .pi / 8)
        let image = UIImage(named: "saltire")
        image?.draw(at: CGPoint(x: 600, y: 400))
    }

    showOutput(rendered)