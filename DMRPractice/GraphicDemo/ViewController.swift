//
//  ViewController.swift
//  GraphicDemo
//
//  Created by Riven on 2020/11/9.
//  Copyright © 2020 Riven. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let testView = CGView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 300))
        view.addSubview(testView)
    }
    
}

class CGView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawLine()
    }
    
    // 绘制线条
        fileprivate func drawLine() {
            // 获取图形上下文
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            
            // 创建一个矩形
            let rect = bounds
            let drawingRect = rect.insetBy(dx: 3, dy: 3)
            
            // 创建绘制路径
            let path = CGMutablePath()
            path.move(to: CGPoint(x: drawingRect.minX, y: drawingRect.minY))
            path.addLine(to: CGPoint(x: drawingRect.maxX, y: drawingRect.minY))
//            path.addLine(to: CGPoint(x: drawingRect.maxX, y: drawingRect.maxY))
//            path.addLine(to: CGPoint(x: drawingRect.minX, y: drawingRect.maxY))
//            path.addLine(to: CGPoint(x: drawingRect.minX, y: drawingRect.minY))

//            path.addRect(CGRect(x: 20, y: 20, width: 50, height: 50))
            
            context.addPath(path)
            
            // 设置画笔颜色
            context.setStrokeColor(UIColor.red.cgColor)
            
            // 设置画笔宽度
            context.setLineWidth(2)
            
            // 绘制路径
//            context.strokePath()
            
            // 设置填充颜色
            context.setFillColor(UIColor.orange.cgColor)
//            context.fillPath()
            context.drawPath(using: .fillStroke)
        }
    
}

