//
//  WriteView.swift
//  PleaseWork
//
//  Created by Hazel Egan on 03/03/2016.
//  Copyright © 2016 Hazel Egan. All rights reserved.
//

import UIKit

class WriteView: UIView {
    var lines =  [CGPoint]()
    var drawImage: UIImage?
    let path = UIBezierPath()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .whiteColor()
        
        path.lineCapStyle = .Round
        path.lineJoinStyle = .Round
        path.lineWidth = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        lines.append(touch.locationInView(self))
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        for coalescedTouch in event!.coalescedTouchesForTouch(touch)! {
            lines.append(coalescedTouch.locationInView(self))
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        
        drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
        drawImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        lines.removeAll()
    }
    
    func getMidpointFromPointA(a: CGPoint, andB b: CGPoint) ->  CGPoint {
        return CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
    }
    
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetAllowsAntialiasing(context, true)
        CGContextSetShouldAntialias(context, true)
        
        UIColor.blackColor().setStroke()
        
        path.removeAllPoints()
        
        drawImage?.drawInRect(rect)
        
        if !lines.isEmpty {
            path.moveToPoint(lines.first!)
            path.addLineToPoint(getMidpointFromPointA(lines.first!, andB: lines[1]))
            
            for index in 1..<lines.count - 1 {
                let midpoint = getMidpointFromPointA(lines[index], andB: lines[index-1])
                
                path.addQuadCurveToPoint(midpoint, controlPoint: lines[index])
            }
            
            path.addLineToPoint(lines.last!)
            
            path.stroke()
        }
        
        
    }
    
    
}
