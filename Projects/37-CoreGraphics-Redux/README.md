# Core Graphics Redux

## This playground lets us walk through a variety of Core Graphics techniques.

### 1.Rectangles

#### When you run the code below, it will create a 1000x1000 image with a 600x600 blue box in its center, then display it in the image view you'll see in the playground live view.

##### > Can you write some code to draw a red box on top of the blue one, making it 200x200 and centered like the blue one?

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

##### > Can you draw the five rectangles in their correct colors? The first one has been done for you.

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

##### > Recreate your designer's image, but this time using a yellow background and an orange cross. Your designer suggested a couple of lines for you, which should give you a headstart.

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

##### > The code below makes a checkerboard, but it doesn't fill the image correctly. Try adjusting the grid size, number of rows, and number of columns so that you get a 10x10 checkerboard across the entire image.

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

##### > The code below draws one red circle in the top-left corner, but your designer wants you to create three more: a yellow circle in the top-right corner, a blue circle in the bottom-left corner, and a green circle in the bottom-right corner.

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

##### > Your designer has provided a sketch of what they want: four red circles, with a black circle in the middle. Can you make this happen using ellipses? They've drawn the first one for you, but it isn't quite right.

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

##### > Can you recreate their logo sketch using ellipses, strokes, and fills? They already added the first circle for you, which should give you a nice template for the others.

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

##### > Your designer has produced a sketch showing how it should look. Can you adjust the code to help make it work correctly?

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
