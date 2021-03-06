//
//  GraphView.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-01-28.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import UIKit

class GraphView: UIView {
    
    
    let margin:CGFloat = 20.0
    let topBorder:CGFloat = 20
    let bottomBorder:CGFloat = 20
    
    var yValues:[Int] = []

    var xValues:[String] = []
    var xLabels:[UILabel] = []
    
    var topColour: UIColor = UIColor.redGraphColor()
    var bottomColour: UIColor = UIColor.yellowGraphColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sizeToFit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    func addXLabelWithText(xValue:String) {
        
        xValues.append(xValue)
        let xLabel = UILabel(frame: CGRectZero)
        xLabel.text = " \(xValue)"
        xLabel.font = UIFont(name: "AvenirNextCondensed-Medium", size: 13)
        xLabel.textColor = UIColor.whiteColor()
        print("xLabel.text: \(xLabel.text)")
        xLabels.append(xLabel)
        addSubview(xLabel)
        setNeedsLayout()
        
    }
    

    override func layoutSubviews() {
        
        //let width = frame.width
        let height = frame.height

        let labelWidth:CGFloat = 44
        
        var labelFrame = CGRect(x: 0, y: 0, width: labelWidth, height: 14)

        // Offset each label's origin by the length of the label plus spacing.
        for (index, label) in xLabels.enumerate() {            
            labelFrame.origin.x = xPoint(index) - labelWidth/2
    
            labelFrame.origin.y = height - 15
            
            label.frame = labelFrame
            print("[\(index)] LABEL TEXT:\(label.text), xValue: \(xValues[index])")
            
            
        }
        
//        let widthOfLabelsCombined = labelFrame.width * CGFloat(xLabels.count)
//        let maximumGraphWidth = frame.width - margin*2
//        
//        if (widthOfLabelsCombined > maximumGraphWidth) {
//            xLabels.removeFirst()
//            yValues.removeFirst()
//            xValues.removeFirst()
//            setNeedsLayout()
//        }
        /// TO DO: check if labelWidth*xLabels.count > width then shift the graph over so it shows the most recent dates

       
    }
    
 
    // for setting up labels on the x axis
    // xValues are the label text
    // this should only be called once
    func setUpXLabels(xValues:[String]) {
        
        self.xValues = xValues

//        if startAtZero {
//            self.yValues.insert(0, atIndex: 0)
//            self.xValues.insert(" ", atIndex: 0)
//        }
    

        for xLabel in xLabels {
            xLabel.removeFromSuperview()
        }
    
        self.xLabels.removeAll()

        let labelFrame = CGRect(x:0, y:0, width:30, height:44)
        
        
        for i in 0..<xValues.count {

            let xLabel = UILabel(frame:labelFrame)
            
            xLabel.text = "\(xValues[i])"
            
            xLabel.font = UIFont(name: "AvenirNextCondensed-Medium", size: 13)
            xLabel.textAlignment = .Center
            xLabel.textColor = UIColor.whiteColor()
            
            
            xLabels.append(xLabel)
            addSubview(xLabel)

            
        }
//        setNeedsLayout() // layout if needed
//        setNeedsDisplay()
    
    }
    
    
    // dont show the point on the graph if the yValue = -1, this indicates that no data has been added for that date and should be removed.
//    func setUpYValues(yValues:[Int]) {
//        
//        var tempYValues = yValues
//        for i in 0..<yValues.count {
//            
//            if yValues[i] == -1 {
//                xLabels.removeAtIndex(i)
//                xValues.removeAtIndex(i)
//                tempYValues.removeAtIndex(i)
//            }
//        }
//        
//        self.yValues = tempYValues
//        setNeedsLayout()
//        
//    }
    
    func arrangeLabelsToFitWidth() {
        
        
    }
    
    
    // placeholder for no content
    lazy var noDataLabel:UILabel = {
        
        let width = self.frame.width
        let height = self.frame.height
        
        let center:CGPoint = CGPoint(x:width/2, y:height/2)
        
        let noDataLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width/3, height: height/3))
        noDataLabel.center = center
        noDataLabel.text = "No data to show"
        noDataLabel.font = UIFont(name: "AvenirNextCondensed-Medium", size: 24)
        noDataLabel.textAlignment = .Center
        
        noDataLabel.textColor = UIColor.lightTextColor()
        
        return noDataLabel
        
    }()

    
    
    
    

//    override func sizeThatFits(size: CGSize) -> CGSize {
//        let screenWidth = UIScreen.mainScreen().bounds.size.width
//        let screenHeight = UIScreen.mainScreen().bounds.size.height
//        
//        let orientation:UIDeviceOrientation = UIDevice.currentDevice().orientation
//
//        var width:CGFloat = size.width
//        var height:CGFloat = size.height
//        if orientation == .LandscapeLeft {
//            if size.width < screenWidth {
//                width = screenWidth
//            }
//        }
//        else if orientation == .Portrait {
//            if size.height < screenHeight {
//                height = screenHeight
//            }
//        }
//        return CGSize(width: width, height: height)
//        
//    }
    
    func xPoint(index:Int) -> CGFloat {

        let width = frame.width
        let columnXPoint = { (column:Int) -> CGFloat in
            //Calculate gap between points
            
//            let spacer = (self.frame.width - self.margin*2 - 4) /
//                CGFloat((self.yValues.count - 1))
            var spacer:CGFloat = width - self.margin*2 - 4
            if self.yValues.count-1 > 0 {
                spacer = spacer/CGFloat((self.yValues.count - 1))
            }
            var x:CGFloat = CGFloat(column) * spacer
            x += self.margin + 2 // -2
            return x
        }
        return columnXPoint(index)
    }

 
  
    func yPoint(yValue:Int) -> CGFloat {
        let height = frame.height

        let maxValue = yValues.maxElement()!

        let graphHeight = height - topBorder - bottomBorder
        
        
        let columnYPoint = { (graphPoint:Int) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint) /
                CGFloat(maxValue) * graphHeight
            y = graphHeight + self.topBorder - y // Flip the graph
            return y
        }
        
        return columnYPoint(yValue)
        
    }
    
    override func drawRect(rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        let graphHeight = self.frame.height - topBorder - bottomBorder
        
        //set up background clipping area
        let path = UIBezierPath(roundedRect: rect,
            byRoundingCorners: UIRectCorner.AllCorners,
            cornerRadii: CGSize(width: 5.0, height: 5.0))
        path.addClip()
        
        // No data has been added by the user yet (the initial point starting at zero)
        if yValues.count < 2 {
            addSubview(noDataLabel)
            return
        }
        noDataLabel.hidden = true
        
        //
        var maxValue = yValues.maxElement()!
        if (maxValue < 1) {
            maxValue = 1
        }

        
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

        // draw the line graph
        
        UIColor.whiteColor().setFill()
        UIColor.whiteColor().setStroke()
        
        //set up the points line
        let graphPath = UIBezierPath()
        //go to start of line
    
        graphPath.moveToPoint(CGPoint(x:xPoint(0),
            y:yPoint(yValues[0])))
        
        
        
        
        //add points for each item in the graphPoints array
        //at the correct (x, y) for the point
        for i in 1..<yValues.count {
            let nextPoint = CGPoint(x:xPoint(i),
                y:yPoint(yValues[i]))
            graphPath.addLineToPoint(nextPoint)
        }
        
        
        
        
        //Create the clipping path for the graph gradient
        
        //1 - save the state of the context
        CGContextSaveGState(context)
        
        //2 - make a copy of the path
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        //3 - add lines to the copied path to complete the clip area
        clippingPath.addLineToPoint(CGPoint(
            x: xPoint(yValues.count - 1),
            y:height))
        clippingPath.addLineToPoint(CGPoint(
            x:xPoint(0),
            y:height))
        clippingPath.closePath()
        
        //4 - add the clipping path to the context
        clippingPath.addClip()
        

        let highestYPoint = yPoint(maxValue)
        startPoint = CGPoint(x:margin, y: highestYPoint)
        endPoint = CGPoint(x:margin, y:self.bounds.height)
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, [])
        CGContextRestoreGState(context)
        
        //draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        //Draw the circles on top of graph stroke
        for i in 0..<yValues.count {
            var point = CGPoint(x:xPoint(i), y:yPoint(yValues[i]))
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

    }
}