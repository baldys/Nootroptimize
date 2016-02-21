// Use Swift operator overloading to blend two UIColors with the addition operator

import UIKit

extension UIColor {
    static func colorWithRedValue(redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alpha)
    }
    
    /// MOOD
    // top
    class func redGraphColor() -> UIColor {
        return colorWithRedValue(250, greenValue:63, blueValue:32, alpha:1)
    }
    // bottom
    class func yellowGraphColor() -> UIColor {
        return colorWithRedValue(255, greenValue:232, blueValue:0, alpha:1)
    }
    
    // top
    class func aquaGraphColour() -> UIColor {
        return colorWithRedValue(0, greenValue:250, blueValue:199, alpha:1)
    }
    // bottom
    class func turquoiseGraphColour() -> UIColor {
        return colorWithRedValue(23, greenValue:186, blueValue:250, alpha:1)
    }
    
    /// yellowColor - top
    // bottom
    class func greenGraphColour() -> UIColor {
        return colorWithRedValue(19, greenValue:220, blueValue:0, alpha:1)
    }

    // top
    class func blueGraphColour() -> UIColor {
        return colorWithRedValue(0, greenValue:175, blueValue:255, alpha:1)
    }
    // bottom
    class func darkPurpleGraphColour() -> UIColor {
        return colorWithRedValue(75, greenValue:5, blueValue:220, alpha:1)
    }
    
    // top
    class func purpleGraphColour() -> UIColor {
        return colorWithRedValue(118, greenValue:58, blueValue:242, alpha:1)
    }
    // bottom
    class func pinkGraphColor() -> UIColor {
        return colorWithRedValue(250, greenValue:73, blueValue:233, alpha:1)
    }
}


// colour blender
func + (left: UIColor, right: UIColor) -> UIColor {
    
    var leftRGBA = [CGFloat](count: 4, repeatedValue: 0.0)
    var rightRGBA = [CGFloat](count: 4, repeatedValue: 0.0)
    
    left.getRed(&leftRGBA[0], green: &leftRGBA[1], blue: &leftRGBA[2], alpha: &leftRGBA[3])
    right.getRed(&rightRGBA[0], green: &rightRGBA[1], blue: &rightRGBA[2], alpha: &rightRGBA[3])
    
    return UIColor(
        red: (leftRGBA[0] + rightRGBA[0]) / 2,
        green: (leftRGBA[1] + rightRGBA[1]) / 2,
        blue: (leftRGBA[2] + rightRGBA[2]) / 2,
        alpha: (leftRGBA[3] + rightRGBA[3]) / 2
    )
}

//UIColor.yellowColor() + UIColor.redColor()
//UIColor.greenColor() + UIColor.blueColor()
//UIColor.purpleColor() + UIColor.orangeColor()
