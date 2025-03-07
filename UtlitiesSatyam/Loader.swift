//
//  Loader.swift
//  RPG
//
//  Created by satyam dwivedi on 07/02/24.
//


import UIKit

class GameLoaderView: UIView {
    let activityIndicatorView: UIActivityIndicatorView
    
    override init(frame: CGRect) {
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        activityIndicatorView.color = .white
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func startAnimating() {
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
    
    // Class methods for showing and hiding the loader
    
    class func show(in view: UIView) {
         view.endEditing(true)
        let loaderView = GameLoaderView(frame: view.bounds)
        loaderView.tag = 999 // Tag to identify the loader view
        view.addSubview(loaderView)
        loaderView.startAnimating()
    }
    
    class func hide(from view: UIView) {
        if let loaderView = view.viewWithTag(999) as? GameLoaderView {
            loaderView.stopAnimating()
            loaderView.removeFromSuperview()
        }
    }
}

extension UIViewController {
    
     func addShadowOnViewWithGradiebt(view_Main:UIView) {
        // Auto layout, variables, and unit scale are not yet supported
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view.alpha = 0.7
        let shadows = UIView()
        shadows.frame = view.frame
        shadows.clipsToBounds = false
        view.addSubview(shadows)

        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 28)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 5
        layer0.shadowOffset = CGSize(width: 0, height: -5)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)

        let shapes = UIView()
        shapes.frame = view.frame
        shapes.clipsToBounds = true
        view.addSubview(shapes)

        let layer1 = CALayer()
        layer1.backgroundColor = UIColor(red: 0.037, green: 0.081, blue: 0.133, alpha: 1).cgColor
        layer1.bounds = shapes.bounds
        layer1.position = shapes.center
        shapes.layer.addSublayer(layer1)

        shapes.layer.cornerRadius = 28
        
        view_Main.addSubview(view)
        view_Main.sendSubviewToBack(view)
    }
}
extension Date {
    static func getCurrentDateForName() -> String {
        return self.getCustomDate(formet: "dd_MM_yyyy_HH_mm_ss_a", date: Date())
    }
    static func getCurrentDate(formet:String = "MM/dd/yyyy HH:mm:ss a") -> String {
        return self.getCustomDate(formet: formet, date: Date())
    }
    static func getCustomDate(formet:String = "MM/dd/yyyy HH:mm:ss a", date: Date = Date()) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formet
        return dateFormatter.string(from: date)
    }
    func formatDate(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
