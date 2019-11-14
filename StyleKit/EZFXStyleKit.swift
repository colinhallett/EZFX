//
//  EZFXStyleKit.swift
//  EZFX
//
//  Created by Colin on 14/11/2019.
//  Copyright © 2019 Colin. All rights reserved.
//
//  Generated by PaintCode
//  http://www.paintcodeapp.com
//



import UIKit

public class EZFXStyleKit : NSObject {

    //// Drawing Methods

    @objc dynamic public class func drawEZBlueKnob(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200), resizing: ResizingBehavior = .aspectFit, knobValue: CGFloat = 0.657, knobName: String = "KnobName") {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 200, height: 200), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 200, y: resizedFrame.height / 200)


        //// Color Declarations
        let color = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        let knobLinePathFill = UIColor(red: 0.228, green: 0.113, blue: 0.638, alpha: 0.401)
        let blueKnobFill = UIColor(red: 0.061, green: 0.056, blue: 0.905, alpha: 1.000)

        //// Variable Declarations
        let knobLinePath: CGFloat = -120 - knobValue * 300
        let knobKnobRotation: CGFloat = -268 - knobValue * 300

        //// Oval 6 Drawing
        let oval6Path = UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 184, height: 184))
        UIColor.black.setFill()
        oval6Path.fill()
        color.setStroke()
        oval6Path.lineWidth = 4
        oval6Path.lineCapStyle = .round
        oval6Path.stroke()


        //// Oval Drawing
        context.saveGState()
        context.setAlpha(0.7)

        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 39.5, y: 40.5, width: 120, height: 120))
        UIColor.white.setStroke()
        ovalPath.lineWidth = 5.5
        ovalPath.stroke()

        context.restoreGState()


        //// Oval 2 Drawing
        context.saveGState()
        context.setAlpha(0.7)

        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 19.5, y: 20.5, width: 160, height: 160))
        UIColor.white.setStroke()
        oval2Path.lineWidth = 5.5
        oval2Path.stroke()

        context.restoreGState()


        //// Oval 3 Drawing
        let oval3Rect = CGRect(x: 8, y: 8, width: 184, height: 184)
        let oval3Path = UIBezierPath()
        oval3Path.addArc(withCenter: CGPoint(x: oval3Rect.midX, y: oval3Rect.midY), radius: oval3Rect.width / 2, startAngle: 120 * CGFloat.pi/180, endAngle: 60 * CGFloat.pi/180, clockwise: true)

        knobLinePathFill.setStroke()
        oval3Path.lineWidth = 7
        oval3Path.lineCapStyle = .square
        oval3Path.stroke()


        //// Oval 4 Drawing
        let oval4Rect = CGRect(x: 8, y: 8, width: 184, height: 184)
        let oval4Path = UIBezierPath()
        oval4Path.addArc(withCenter: CGPoint(x: oval4Rect.midX, y: oval4Rect.midY), radius: oval4Rect.width / 2, startAngle: 120 * CGFloat.pi/180, endAngle: -knobLinePath * CGFloat.pi/180, clockwise: true)

        blueKnobFill.setStroke()
        oval4Path.lineWidth = 7
        oval4Path.lineCapStyle = .square
        oval4Path.stroke()


        //// Oval 5 Drawing
        context.saveGState()
        context.translateBy(x: 100, y: 100)
        context.rotate(by: -knobKnobRotation * CGFloat.pi/180)

        let oval5Path = UIBezierPath(ovalIn: CGRect(x: -63.7, y: -38.64, width: 8, height: 8))
        UIColor.white.setFill()
        oval5Path.fill()
        UIColor.white.setStroke()
        oval5Path.lineWidth = 1
        oval5Path.lineCapStyle = .round
        oval5Path.stroke()

        context.restoreGState()


        //// knobNameLabel Drawing
        let knobNameLabelRect = CGRect(x: 50, y: 75, width: 101, height: 49)
        let knobNameLabelStyle = NSMutableParagraphStyle()
        knobNameLabelStyle.alignment = .center
        let knobNameLabelFontAttributes = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.white,
            .paragraphStyle: knobNameLabelStyle,
        ] as [NSAttributedString.Key: Any]

        let knobNameLabelTextHeight: CGFloat = knobName.boundingRect(with: CGSize(width: knobNameLabelRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: knobNameLabelFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: knobNameLabelRect)
        knobName.draw(in: CGRect(x: knobNameLabelRect.minX, y: knobNameLabelRect.minY + (knobNameLabelRect.height - knobNameLabelTextHeight) / 2, width: knobNameLabelRect.width, height: knobNameLabelTextHeight), withAttributes: knobNameLabelFontAttributes)
        context.restoreGState()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawVerticalSlider(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 370), resizing: ResizingBehavior = .aspectFit, verticalSliderValue: CGFloat = 0) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 100, height: 370), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 100, y: resizedFrame.height / 370)


        //// Color Declarations
        let knobLineFill = UIColor(red: 0.104, green: 0.161, blue: 0.853, alpha: 1.000)
        let knobLinePathFill = UIColor(red: 0.228, green: 0.113, blue: 0.638, alpha: 0.401)

        //// Variable Declarations
        let sliderButtonPosition: CGFloat = 343 - verticalSliderValue * 340
        let verticalSliderAmountFill: CGFloat = 1 + verticalSliderValue * 346

        //// SliderBG Drawing
        let sliderBGPath = UIBezierPath(roundedRect: CGRect(x: 18, y: 16, width: 64, height: 346), cornerRadius: 5)
        knobLinePathFill.setFill()
        sliderBGPath.fill()


        //// SliderAmountFill Drawing
        context.saveGState()
        context.translateBy(x: 50, y: 198)
        context.rotate(by: -180 * CGFloat.pi/180)

        let sliderAmountFillPath = UIBezierPath(roundedRect: CGRect(x: -31.74, y: -164, width: 63.48, height: verticalSliderAmountFill), cornerRadius: 0.5)
        knobLineFill.setFill()
        sliderAmountFillPath.fill()

        context.restoreGState()


        //// Rectangle 3 Drawing
        let rectangle3Path = UIBezierPath(roundedRect: CGRect(x: 18, y: 16, width: 64, height: 346), cornerRadius: 5)
        knobLinePathFill.setFill()
        rectangle3Path.fill()
        UIColor.white.setStroke()
        rectangle3Path.lineWidth = 5.5
        rectangle3Path.stroke()


        //// SliderButton Drawing
        let sliderButtonPath = UIBezierPath(roundedRect: CGRect(x: 5, y: sliderButtonPosition, width: 90, height: 25), cornerRadius: 5)
        UIColor.black.setFill()
        sliderButtonPath.fill()
        UIColor.white.setStroke()
        sliderButtonPath.lineWidth = 3
        sliderButtonPath.stroke()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawHorizontalSlider(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 450, height: 75), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 450, height: 75), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 450, y: resizedFrame.height / 75)
        
        context.restoreGState()

    }

    @objc dynamic public class func drawToggleButton(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 77, height: 79), resizing: ResizingBehavior = .aspectFit, toggleOn: Bool = false) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 77, height: 79), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 77, y: resizedFrame.height / 79)
        let resizedShadowScale: CGFloat = min(resizedFrame.width / 77, resizedFrame.height / 79)


        //// Color Declarations
        let gradientColor4 = UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1.000)
        let gradientColor6 = UIColor(red: 0.102, green: 0.102, blue: 0.102, alpha: 1.000)
        let fillColor6 = UIColor(red: 1.000, green: 0.996, blue: 0.859, alpha: 1.000)
        let strokeColor6 = UIColor(red: 0.290, green: 0.286, blue: 0.286, alpha: 1.000)

        //// Gradient Declarations
        let radialgradient5 = CGGradient(colorsSpace: nil, colors: [gradientColor6.cgColor, gradientColor4.cgColor] as CFArray, locations: [0, 1])!

        //// Shadow Declarations
        let onlight = NSShadow()
        onlight.shadowColor = UIColor.white
        onlight.shadowOffset = CGSize(width: 0, height: 0)
        onlight.shadowBlurRadius = 8
        let shadow3 = NSShadow()
        shadow3.shadowColor = UIColor.white.withAlphaComponent(0.41)
        shadow3.shadowOffset = CGSize(width: 2, height: 3)
        shadow3.shadowBlurRadius = 5
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.48)
        shadow.shadowOffset = CGSize(width: 3, height: 3)
        shadow.shadowBlurRadius = 5

        //// Group_34
        //// Rectangle_109
        //// Rectangle 5 Drawing
        context.saveGState()
        context.setAlpha(0.8)

        let rectangle5Path = UIBezierPath(roundedRect: CGRect(x: 8, y: 11, width: 61, height: 61), cornerRadius: 1.5)
        context.saveGState()
        rectangle5Path.addClip()
        context.drawRadialGradient(radialgradient5,
            startCenter: CGPoint(x: 38.5, y: 41.5), startRadius: 0,
            endCenter: CGPoint(x: 38.5, y: 41.5), endRadius: 25.28,
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        context.restoreGState()

        context.restoreGState()




        //// Rectangle_
        context.saveGState()
        context.setShadow(offset: CGSize(width: shadow.shadowOffset.width * resizedShadowScale, height: shadow.shadowOffset.height * resizedShadowScale), blur: shadow.shadowBlurRadius * resizedShadowScale, color: (shadow.shadowColor as! UIColor).cgColor)
        context.beginTransparencyLayer(auxiliaryInfo: nil)


        //// Rectangle 8 Drawing
        let rectangle8Path = UIBezierPath(roundedRect: CGRect(x: 7.7, y: 10.7, width: 61.5, height: 61.5), cornerRadius: 1.5)
        context.saveGState()
        context.setShadow(offset: CGSize(width: shadow3.shadowOffset.width * resizedShadowScale, height: shadow3.shadowOffset.height * resizedShadowScale), blur: shadow3.shadowBlurRadius * resizedShadowScale, color: (shadow3.shadowColor as! UIColor).cgColor)
        strokeColor6.setStroke()
        rectangle8Path.lineWidth = 0.5
        rectangle8Path.stroke()
        context.restoreGState()


        if (toggleOn) {
            //// Rectangle Drawing
            let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 7.75, y: 10.75, width: 61.5, height: 61.5), cornerRadius: 1.5)
            context.saveGState()
            context.setShadow(offset: CGSize(width: onlight.shadowOffset.width * resizedShadowScale, height: onlight.shadowOffset.height * resizedShadowScale), blur: onlight.shadowBlurRadius * resizedShadowScale, color: (onlight.shadowColor as! UIColor).cgColor)
            fillColor6.setStroke()
            rectanglePath.lineWidth = 0.5
            rectanglePath.stroke()
            context.restoreGState()
        }


        context.endTransparencyLayer()
        context.restoreGState()


        //// Ellipse_
        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 26.23, y: 28.23, width: 24.46, height: 24.46))
        gradientColor6.setFill()
        oval2Path.fill()


        if (toggleOn) {
            //// Oval Drawing
            let ovalPath = UIBezierPath(ovalIn: CGRect(x: 26.23, y: 28.23, width: 24.46, height: 24.46))
            context.saveGState()
            context.setShadow(offset: CGSize(width: onlight.shadowOffset.width * resizedShadowScale, height: onlight.shadowOffset.height * resizedShadowScale), blur: onlight.shadowBlurRadius * resizedShadowScale, color: (onlight.shadowColor as! UIColor).cgColor)
            fillColor6.setFill()
            ovalPath.fill()
            context.restoreGState()

        }
        
        context.restoreGState()

    }

    @objc dynamic public class func drawEZOrangeKnob(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200), resizing: ResizingBehavior = .aspectFit, knobValue: CGFloat = 0.657, knobName: String = "KnobName") {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 200, height: 200), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 200, y: resizedFrame.height / 200)


        //// Color Declarations
        let color = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        let orangeKnobFill = UIColor(red: 1.000, green: 0.411, blue: 0.000, alpha: 1.000)
        let orangeKnobLine = UIColor(red: 0.432, green: 0.275, blue: 0.201, alpha: 1.000)

        //// Variable Declarations
        let knobLinePath: CGFloat = -120 - knobValue * 300
        let knobKnobRotation: CGFloat = -268 - knobValue * 300

        //// Oval 6 Drawing
        let oval6Path = UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 184, height: 184))
        UIColor.black.setFill()
        oval6Path.fill()
        color.setStroke()
        oval6Path.lineWidth = 4
        oval6Path.lineCapStyle = .round
        oval6Path.stroke()


        //// Oval Drawing
        context.saveGState()
        context.setAlpha(0.7)

        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 39.5, y: 40.5, width: 120, height: 120))
        UIColor.white.setStroke()
        ovalPath.lineWidth = 5.5
        ovalPath.stroke()

        context.restoreGState()


        //// Oval 2 Drawing
        context.saveGState()
        context.setAlpha(0.7)

        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 19.5, y: 20.5, width: 160, height: 160))
        UIColor.white.setStroke()
        oval2Path.lineWidth = 5.5
        oval2Path.stroke()

        context.restoreGState()


        //// Oval 3 Drawing
        let oval3Rect = CGRect(x: 8, y: 8, width: 184, height: 184)
        let oval3Path = UIBezierPath()
        oval3Path.addArc(withCenter: CGPoint(x: oval3Rect.midX, y: oval3Rect.midY), radius: oval3Rect.width / 2, startAngle: 120 * CGFloat.pi/180, endAngle: 60 * CGFloat.pi/180, clockwise: true)

        orangeKnobLine.setStroke()
        oval3Path.lineWidth = 7
        oval3Path.lineCapStyle = .square
        oval3Path.stroke()


        //// Oval 4 Drawing
        let oval4Rect = CGRect(x: 8, y: 8, width: 184, height: 184)
        let oval4Path = UIBezierPath()
        oval4Path.addArc(withCenter: CGPoint(x: oval4Rect.midX, y: oval4Rect.midY), radius: oval4Rect.width / 2, startAngle: 120 * CGFloat.pi/180, endAngle: -knobLinePath * CGFloat.pi/180, clockwise: true)

        orangeKnobFill.setStroke()
        oval4Path.lineWidth = 7
        oval4Path.lineCapStyle = .square
        oval4Path.stroke()


        //// Oval 5 Drawing
        context.saveGState()
        context.translateBy(x: 100, y: 100)
        context.rotate(by: -knobKnobRotation * CGFloat.pi/180)

        let oval5Path = UIBezierPath(ovalIn: CGRect(x: -63.7, y: -38.64, width: 8, height: 8))
        UIColor.white.setFill()
        oval5Path.fill()
        UIColor.white.setStroke()
        oval5Path.lineWidth = 1
        oval5Path.lineCapStyle = .round
        oval5Path.stroke()

        context.restoreGState()


        //// knobNameLabel Drawing
        let knobNameLabelRect = CGRect(x: 50, y: 75, width: 101, height: 49)
        let knobNameLabelStyle = NSMutableParagraphStyle()
        knobNameLabelStyle.alignment = .center
        let knobNameLabelFontAttributes = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.white,
            .paragraphStyle: knobNameLabelStyle,
        ] as [NSAttributedString.Key: Any]

        let knobNameLabelTextHeight: CGFloat = knobName.boundingRect(with: CGSize(width: knobNameLabelRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: knobNameLabelFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: knobNameLabelRect)
        knobName.draw(in: CGRect(x: knobNameLabelRect.minX, y: knobNameLabelRect.minY + (knobNameLabelRect.height - knobNameLabelTextHeight) / 2, width: knobNameLabelRect.width, height: knobNameLabelTextHeight), withAttributes: knobNameLabelFontAttributes)
        context.restoreGState()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawEZGreenKnob(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200), resizing: ResizingBehavior = .aspectFit, knobValue: CGFloat = 0.657, knobName: String = "KnobName") {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 200, height: 200), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 200, y: resizedFrame.height / 200)


        //// Color Declarations
        let color = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        let greenKnobLine = UIColor(red: 0.168, green: 0.648, blue: 0.088, alpha: 1.000)
        let greenKnobFill = UIColor(red: 0.111, green: 0.324, blue: 0.094, alpha: 1.000)

        //// Variable Declarations
        let knobLinePath: CGFloat = -120 - knobValue * 300
        let knobKnobRotation: CGFloat = -268 - knobValue * 300

        //// Oval 6 Drawing
        let oval6Path = UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 184, height: 184))
        UIColor.black.setFill()
        oval6Path.fill()
        color.setStroke()
        oval6Path.lineWidth = 4
        oval6Path.lineCapStyle = .round
        oval6Path.stroke()


        //// Oval Drawing
        context.saveGState()
        context.setAlpha(0.7)

        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 39.5, y: 40.5, width: 120, height: 120))
        UIColor.white.setStroke()
        ovalPath.lineWidth = 5.5
        ovalPath.stroke()

        context.restoreGState()


        //// Oval 2 Drawing
        context.saveGState()
        context.setAlpha(0.7)

        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 19.5, y: 20.5, width: 160, height: 160))
        UIColor.white.setStroke()
        oval2Path.lineWidth = 5.5
        oval2Path.stroke()

        context.restoreGState()


        //// Oval 3 Drawing
        let oval3Rect = CGRect(x: 8, y: 8, width: 184, height: 184)
        let oval3Path = UIBezierPath()
        oval3Path.addArc(withCenter: CGPoint(x: oval3Rect.midX, y: oval3Rect.midY), radius: oval3Rect.width / 2, startAngle: 120 * CGFloat.pi/180, endAngle: 60 * CGFloat.pi/180, clockwise: true)

        greenKnobFill.setStroke()
        oval3Path.lineWidth = 7
        oval3Path.lineCapStyle = .square
        oval3Path.stroke()


        //// Oval 4 Drawing
        let oval4Rect = CGRect(x: 8, y: 8, width: 184, height: 184)
        let oval4Path = UIBezierPath()
        oval4Path.addArc(withCenter: CGPoint(x: oval4Rect.midX, y: oval4Rect.midY), radius: oval4Rect.width / 2, startAngle: 120 * CGFloat.pi/180, endAngle: -knobLinePath * CGFloat.pi/180, clockwise: true)

        greenKnobLine.setStroke()
        oval4Path.lineWidth = 7
        oval4Path.lineCapStyle = .square
        oval4Path.stroke()


        //// Oval 5 Drawing
        context.saveGState()
        context.translateBy(x: 100, y: 100)
        context.rotate(by: -knobKnobRotation * CGFloat.pi/180)

        let oval5Path = UIBezierPath(ovalIn: CGRect(x: -63.7, y: -38.64, width: 8, height: 8))
        UIColor.white.setFill()
        oval5Path.fill()
        UIColor.white.setStroke()
        oval5Path.lineWidth = 1
        oval5Path.lineCapStyle = .round
        oval5Path.stroke()

        context.restoreGState()


        //// knobNameLabel Drawing
        let knobNameLabelRect = CGRect(x: 50, y: 75, width: 101, height: 49)
        let knobNameLabelStyle = NSMutableParagraphStyle()
        knobNameLabelStyle.alignment = .center
        let knobNameLabelFontAttributes = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.white,
            .paragraphStyle: knobNameLabelStyle,
        ] as [NSAttributedString.Key: Any]

        let knobNameLabelTextHeight: CGFloat = knobName.boundingRect(with: CGSize(width: knobNameLabelRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: knobNameLabelFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: knobNameLabelRect)
        knobName.draw(in: CGRect(x: knobNameLabelRect.minX, y: knobNameLabelRect.minY + (knobNameLabelRect.height - knobNameLabelTextHeight) / 2, width: knobNameLabelRect.width, height: knobNameLabelTextHeight), withAttributes: knobNameLabelFontAttributes)
        context.restoreGState()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawEZRedKnob(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200), resizing: ResizingBehavior = .aspectFit, knobValue: CGFloat = 0.657, knobName: String = "KnobName") {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 200, height: 200), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 200, y: resizedFrame.height / 200)


        //// Color Declarations
        let color = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        let redKnobFill = UIColor(red: 0.854, green: 0.129, blue: 0.129, alpha: 1.000)
        let redKnobLine = UIColor(red: 0.385, green: 0.038, blue: 0.038, alpha: 1.000)

        //// Variable Declarations
        let knobLinePath: CGFloat = -120 - knobValue * 300
        let knobKnobRotation: CGFloat = -268 - knobValue * 300

        //// Oval 6 Drawing
        let oval6Path = UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 184, height: 184))
        UIColor.black.setFill()
        oval6Path.fill()
        color.setStroke()
        oval6Path.lineWidth = 4
        oval6Path.lineCapStyle = .round
        oval6Path.stroke()


        //// Oval Drawing
        context.saveGState()
        context.setAlpha(0.7)

        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 39.5, y: 40.5, width: 120, height: 120))
        UIColor.white.setStroke()
        ovalPath.lineWidth = 5.5
        ovalPath.stroke()

        context.restoreGState()


        //// Oval 2 Drawing
        context.saveGState()
        context.setAlpha(0.7)

        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 19.5, y: 20.5, width: 160, height: 160))
        UIColor.white.setStroke()
        oval2Path.lineWidth = 5.5
        oval2Path.stroke()

        context.restoreGState()


        //// Oval 3 Drawing
        let oval3Rect = CGRect(x: 8, y: 8, width: 184, height: 184)
        let oval3Path = UIBezierPath()
        oval3Path.addArc(withCenter: CGPoint(x: oval3Rect.midX, y: oval3Rect.midY), radius: oval3Rect.width / 2, startAngle: 120 * CGFloat.pi/180, endAngle: 60 * CGFloat.pi/180, clockwise: true)

        redKnobLine.setStroke()
        oval3Path.lineWidth = 7
        oval3Path.lineCapStyle = .square
        oval3Path.stroke()


        //// Oval 4 Drawing
        let oval4Rect = CGRect(x: 8, y: 8, width: 184, height: 184)
        let oval4Path = UIBezierPath()
        oval4Path.addArc(withCenter: CGPoint(x: oval4Rect.midX, y: oval4Rect.midY), radius: oval4Rect.width / 2, startAngle: 120 * CGFloat.pi/180, endAngle: -knobLinePath * CGFloat.pi/180, clockwise: true)

        redKnobFill.setStroke()
        oval4Path.lineWidth = 7
        oval4Path.lineCapStyle = .square
        oval4Path.stroke()


        //// Oval 5 Drawing
        context.saveGState()
        context.translateBy(x: 100, y: 100)
        context.rotate(by: -knobKnobRotation * CGFloat.pi/180)

        let oval5Path = UIBezierPath(ovalIn: CGRect(x: -63.7, y: -38.64, width: 8, height: 8))
        UIColor.white.setFill()
        oval5Path.fill()
        UIColor.white.setStroke()
        oval5Path.lineWidth = 1
        oval5Path.lineCapStyle = .round
        oval5Path.stroke()

        context.restoreGState()


        //// knobNameLabel Drawing
        let knobNameLabelRect = CGRect(x: 50, y: 75, width: 101, height: 49)
        let knobNameLabelStyle = NSMutableParagraphStyle()
        knobNameLabelStyle.alignment = .center
        let knobNameLabelFontAttributes = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.white,
            .paragraphStyle: knobNameLabelStyle,
        ] as [NSAttributedString.Key: Any]

        let knobNameLabelTextHeight: CGFloat = knobName.boundingRect(with: CGSize(width: knobNameLabelRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: knobNameLabelFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: knobNameLabelRect)
        knobName.draw(in: CGRect(x: knobNameLabelRect.minX, y: knobNameLabelRect.minY + (knobNameLabelRect.height - knobNameLabelTextHeight) / 2, width: knobNameLabelRect.width, height: knobNameLabelTextHeight), withAttributes: knobNameLabelFontAttributes)
        context.restoreGState()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawEZPurpleKnob(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200), resizing: ResizingBehavior = .aspectFit, knobValue: CGFloat = 0.657, knobName: String = "KnobName") {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 200, height: 200), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 200, y: resizedFrame.height / 200)


        //// Color Declarations
        let color = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        let purpleKnobLine = UIColor(red: 0.470, green: 0.090, blue: 0.742, alpha: 1.000)
        let purpleKnobFill = UIColor(red: 0.216, green: 0.039, blue: 0.421, alpha: 1.000)

        //// Variable Declarations
        let knobLinePath: CGFloat = -120 - knobValue * 300
        let knobKnobRotation: CGFloat = -268 - knobValue * 300

        //// Oval 6 Drawing
        let oval6Path = UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 184, height: 184))
        UIColor.black.setFill()
        oval6Path.fill()
        color.setStroke()
        oval6Path.lineWidth = 4
        oval6Path.lineCapStyle = .round
        oval6Path.stroke()


        //// Oval Drawing
        context.saveGState()
        context.setAlpha(0.7)

        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 39.5, y: 40.5, width: 120, height: 120))
        UIColor.white.setStroke()
        ovalPath.lineWidth = 5.5
        ovalPath.stroke()

        context.restoreGState()


        //// Oval 2 Drawing
        context.saveGState()
        context.setAlpha(0.7)

        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 19.5, y: 20.5, width: 160, height: 160))
        UIColor.white.setStroke()
        oval2Path.lineWidth = 5.5
        oval2Path.stroke()

        context.restoreGState()


        //// Oval 3 Drawing
        let oval3Rect = CGRect(x: 8, y: 8, width: 184, height: 184)
        let oval3Path = UIBezierPath()
        oval3Path.addArc(withCenter: CGPoint(x: oval3Rect.midX, y: oval3Rect.midY), radius: oval3Rect.width / 2, startAngle: 120 * CGFloat.pi/180, endAngle: 60 * CGFloat.pi/180, clockwise: true)

        purpleKnobFill.setStroke()
        oval3Path.lineWidth = 7
        oval3Path.lineCapStyle = .square
        oval3Path.stroke()


        //// Oval 4 Drawing
        let oval4Rect = CGRect(x: 8, y: 8, width: 184, height: 184)
        let oval4Path = UIBezierPath()
        oval4Path.addArc(withCenter: CGPoint(x: oval4Rect.midX, y: oval4Rect.midY), radius: oval4Rect.width / 2, startAngle: 120 * CGFloat.pi/180, endAngle: -knobLinePath * CGFloat.pi/180, clockwise: true)

        purpleKnobLine.setStroke()
        oval4Path.lineWidth = 7
        oval4Path.lineCapStyle = .square
        oval4Path.stroke()


        //// Oval 5 Drawing
        context.saveGState()
        context.translateBy(x: 100, y: 100)
        context.rotate(by: -knobKnobRotation * CGFloat.pi/180)

        let oval5Path = UIBezierPath(ovalIn: CGRect(x: -63.7, y: -38.64, width: 8, height: 8))
        UIColor.white.setFill()
        oval5Path.fill()
        UIColor.white.setStroke()
        oval5Path.lineWidth = 1
        oval5Path.lineCapStyle = .round
        oval5Path.stroke()

        context.restoreGState()


        //// knobNameLabel Drawing
        let knobNameLabelRect = CGRect(x: 50, y: 75, width: 101, height: 49)
        let knobNameLabelStyle = NSMutableParagraphStyle()
        knobNameLabelStyle.alignment = .center
        let knobNameLabelFontAttributes = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.white,
            .paragraphStyle: knobNameLabelStyle,
        ] as [NSAttributedString.Key: Any]

        let knobNameLabelTextHeight: CGFloat = knobName.boundingRect(with: CGSize(width: knobNameLabelRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: knobNameLabelFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: knobNameLabelRect)
        knobName.draw(in: CGRect(x: knobNameLabelRect.minX, y: knobNameLabelRect.minY + (knobNameLabelRect.height - knobNameLabelTextHeight) / 2, width: knobNameLabelRect.width, height: knobNameLabelTextHeight), withAttributes: knobNameLabelFontAttributes)
        context.restoreGState()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawSelectionButton(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 77, height: 79), resizing: ResizingBehavior = .aspectFit, selectionText: String = "Low Pass Filter", selected: Bool = false) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 77, height: 79), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 77, y: resizedFrame.height / 79)
        let resizedShadowScale: CGFloat = min(resizedFrame.width / 77, resizedFrame.height / 79)


        //// Color Declarations
        let gradientColor4 = UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1.000)
        let strokeColor6 = UIColor(red: 0.290, green: 0.286, blue: 0.286, alpha: 1.000)
        let selectionOn = UIColor(red: 0.569, green: 0.569, blue: 0.569, alpha: 0.462)

        //// Shadow Declarations
        let shadow3 = NSShadow()
        shadow3.shadowColor = UIColor.white.withAlphaComponent(0.41)
        shadow3.shadowOffset = CGSize(width: 2, height: 3)
        shadow3.shadowBlurRadius = 5
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.48)
        shadow.shadowOffset = CGSize(width: 3, height: 3)
        shadow.shadowBlurRadius = 5

        //// Group_34
        //// Rectangle_
        context.saveGState()
        context.setShadow(offset: CGSize(width: shadow.shadowOffset.width * resizedShadowScale, height: shadow.shadowOffset.height * resizedShadowScale), blur: shadow.shadowBlurRadius * resizedShadowScale, color: (shadow.shadowColor as! UIColor).cgColor)
        context.beginTransparencyLayer(auxiliaryInfo: nil)


        //// Rectangle 8 Drawing
        let rectangle8Path = UIBezierPath(roundedRect: CGRect(x: 7.7, y: 10.7, width: 61.5, height: 61.5), cornerRadius: 1.5)
        gradientColor4.setFill()
        rectangle8Path.fill()
        context.saveGState()
        context.setShadow(offset: CGSize(width: shadow3.shadowOffset.width * resizedShadowScale, height: shadow3.shadowOffset.height * resizedShadowScale), blur: shadow3.shadowBlurRadius * resizedShadowScale, color: (shadow3.shadowColor as! UIColor).cgColor)
        strokeColor6.setStroke()
        rectangle8Path.lineWidth = 0.5
        rectangle8Path.stroke()
        context.restoreGState()


        if (selected) {
            //// Rectangle Drawing
            let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 7.75, y: 10.75, width: 61.5, height: 61.5), cornerRadius: 1.5)
            selectionOn.setFill()
            rectanglePath.fill()
            context.saveGState()
            context.setShadow(offset: CGSize(width: shadow3.shadowOffset.width * resizedShadowScale, height: shadow3.shadowOffset.height * resizedShadowScale), blur: shadow3.shadowBlurRadius * resizedShadowScale, color: (shadow3.shadowColor as! UIColor).cgColor)
            strokeColor6.setStroke()
            rectanglePath.lineWidth = 0.5
            rectanglePath.stroke()
            context.restoreGState()
        }


        //// Text Drawing
        let textRect = CGRect(x: 9, y: 11, width: 58, height: 61)
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        let textFontAttributes = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.white,
            .paragraphStyle: textStyle,
        ] as [NSAttributedString.Key: Any]

        let textTextHeight: CGFloat = selectionText.boundingRect(with: CGSize(width: textRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: textRect)
        selectionText.draw(in: CGRect(x: textRect.minX, y: textRect.minY + (textRect.height - textTextHeight) / 2, width: textRect.width, height: textTextHeight), withAttributes: textFontAttributes)
        context.restoreGState()


        context.endTransparencyLayer()
        context.restoreGState()
        
        context.restoreGState()

    }




    @objc(EZFXStyleKitResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
