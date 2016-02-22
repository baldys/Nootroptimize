//
//  GraphView.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-01-28.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import UIKit

class GraphView: UIView {
    
    var yValues:[Int] = []

    var xValues:[String] = []
    var xLabels:[UILabel] = []
    
    

    // yellow
    var topColour: UIColor = UIColor.redGraphColor()
    var bottomColour: UIColor = UIColor.yellowGraphColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    override func layoutSubviews() {
//        
//        
//
//        
//        var labelFrame = CGRect(x: 0, y: 0, width: 66, height: 44)
//        
//        for (index, label) in xLabels.enumerate() {
//            //labelFrame.origin.x = CGFloat(index * (44 + 5)) // index x (width+padding)
//            
//            
//            
//            label.frame = labelFrame
//            
//        }
//        
//
//    }
    
 
    func setUpXLabels(xValues:[String]) {
        self.xValues = xValues
        
        var labelFrame = CGRect(x:0, y:0, width:30, height:44)
        var x:CGFloat = 0
        
        self.xLabels.removeAll()
        
        for i in 0..<xValues.count {
        
            x += 44
            labelFrame.origin.x = x
            let xLabel = UILabel(frame:labelFrame)
            
            xLabel.text = xValues[i]
            
            print("xValue: \(xValues[i])")
            
            xLabel.font = UIFont(name: "AvenirNextCondensed-Medium", size: 13)
            
            xLabel.textColor = UIColor.whiteColor()
            
            //            xLabels += [xLabel]
            xLabels.append(xLabel)
            
            addSubview(xLabel)
            
        }
        setNeedsDisplay()
    }



    override func drawRect(rect: CGRect) {
        if yValues.count == 0 {
            return
        }
        
        let width = rect.width
        let height = rect.height
        
        //set up background clipping area
        let path = UIBezierPath(roundedRect: rect,
            byRoundingCorners: UIRectCorner.AllCorners,
            cornerRadii: CGSize(width: 5.0, height: 5.0)) //8,8
        path.addClip()
        
        //2 - get the current context
        let context = UIGraphicsGetCurrentContext()
        let colors = [topColour.CGColor, bottomColour.CGColor]
        
        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //4 - set up the color stops
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        //5 - create the gradient
        let gradient = CGGradientCreateWithColors(colorSpace,
            colors,
            colorLocations)
        
        //6 - draw the gradient
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x:0, y:self.bounds.height)
        CGContextDrawLinearGradient(context,
            gradient,
            startPoint,
            endPoint,
            [])
        
        //calculate the x point
        
        let margin:CGFloat = 20.0
        let columnXPoint = { (column:Int) -> CGFloat in
            //Calculate gap between points
            let spacer = (width - margin*2 - 4) /
                CGFloat((self.yValues.count - 1))
            var x:CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        
        
        // calculate the y point
        
        let topBorder:CGFloat = 20
        let bottomBorder:CGFloat = 20
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = 10
        //let maxValue = graphPoints.maxElement()!
        let columnYPoint = { (graphPoint:Int) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint) /
                CGFloat(maxValue) * graphHeight
            y = graphHeight + topBorder - y // Flip the graph
            return y
        }
        
        // draw the line graph
        
        UIColor.whiteColor().setFill()
        UIColor.whiteColor().setStroke()
        
        //set up the points line
        let graphPath = UIBezierPath()
        //go to start of line
    
        graphPath.moveToPoint(CGPoint(x:columnXPoint(0),
            y:columnYPoint(yValues[0])))
        
        //add points for each item in the graphPoints array
        //at the correct (x, y) for the point
        for i in 1..<yValues.count {
            let nextPoint = CGPoint(x:columnXPoint(i),
                y:columnYPoint(yValues[i]))
            graphPath.addLineToPoint(nextPoint)
        }
        
        //Create the clipping path for the graph gradient
        
        //1 - save the state of the context
        CGContextSaveGState(context)
        
        //2 - make a copy of the path
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        //3 - add lines to the copied path to complete the clip area
        clippingPath.addLineToPoint(CGPoint(
            x: columnXPoint(yValues.count - 1),
            y:height))
        clippingPath.addLineToPoint(CGPoint(
            x:columnXPoint(0),
            y:height))
        clippingPath.closePath()
        
        //4 - add the clipping path to the context
        clippingPath.addClip()
        
        let highestYPoint = columnYPoint(maxValue)
        startPoint = CGPoint(x:margin, y: highestYPoint)
        endPoint = CGPoint(x:margin, y:self.bounds.height)
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, [])
        CGContextRestoreGState(context)
        
        //draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        //Draw the circles on top of graph stroke
        for i in 0..<yValues.count {
            var point = CGPoint(x:columnXPoint(i), y:columnYPoint(yValues[i]))
            point.x -= 5.0/2
            point.y -= 5.0/2
            
            let circle = UIBezierPath(ovalInRect:
                CGRect(origin: point,
                    size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
        }
        
        
        
        //Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        //top line
        linePath.moveToPoint(CGPoint(x:margin, y: topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin,
            y:topBorder))
        
        //center line
        linePath.moveToPoint(CGPoint(x:margin,
            y: graphHeight/2 + topBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:graphHeight/2 + topBorder))
        
        //bottom line
        linePath.moveToPoint(CGPoint(x:margin,
            y:height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
        
        
        var labelFrame = CGRect(x: 0, y: 0, width: 66, height: 44)
        
        // Offset each button's origin by the length of the button plus spacing.
        for (index, label) in xLabels.enumerate() {
            //labelFrame.origin.x = CGFloat(index * (44 + 5)) // index x (width+padding)
            
            labelFrame.origin.x = columnXPoint(index)
            labelFrame.origin.y = height - 40
            
            label.frame = labelFrame
            print("[\(index)] LABEL TEXT:\(label.text), xValue: \(xValues[index])")
            
            
        }
//        for xValue in xValues {
//            let xLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 44))
//            
//            
//            
//            xLabel.text = xValue
//            print("xValue: \(xValue)")
//            
//            
//            
//            let labelWidth = frame.width/CGFloat(xValues.count)
//            
//            xLabel.sizeThatFits(CGSize(width: labelWidth, height: 44))
//            
//            xLabel.font = UIFont(name: "AvenirNextCondensed-Medium", size: 13)
//            
//            xLabel.textColor = UIColor.whiteColor()
//            
////            xLabels += [xLabel]
//            xLabels.append(xLabel)
//            
//            addSubview(xLabel)
//    
//        }
        
    }
}