//
//  NotificationViewController.swift
//  carouselViewController
//
//  Created by Ekin Bulut on 10.03.2020.
//  Copyright © 2020 Ekin. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import Dengage_Framework
import os.log


open class DengageNotificationViewController: UIViewController, UNNotificationContentExtension {
    
    var dengageCollectionView: UICollectionView!
    
    var bestAttemptContent: UNMutableNotificationContent?
    
    var carouselImages : [String] = [String]()
    var currentIndex : Int = 0
    
    var payloads : [DengageRecievedMessage] = [DengageRecievedMessage]()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        print("viewDidLoad")
        
        
    }
    
    open func viewDidLoad(_ collectionView : UICollectionView!){
        super.viewDidLoad()
        
        self.dengageCollectionView = collectionView
        self.dengageCollectionView.delegate = self as UICollectionViewDelegate
        self.dengageCollectionView.dataSource = self as UICollectionViewDataSource
        self.dengageCollectionView.contentInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }
 
    open func didReceive(_ notification: UNNotification) {
        
        self.bestAttemptContent = (notification.request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent =  bestAttemptContent {
            if let carouselStr = bestAttemptContent.userInfo["urlImageString"] as? String {
                
                
                _ = carouselStr.components(separatedBy: ",")
                self.carouselImages = ["https://i0.wp.com/ekinbulut.com/wp-content/uploads/2020/02/Route_Budapest_To_Dresden.png","https://i2.wp.com/ekinbulut.com/wp-content/uploads/2020/01/20200103_094849-scaled.jpg","https://i1.wp.com/ekinbulut.com/wp-content/uploads/2019/11/tree_reflection_water_night_106375_1024x768.jpg"]
                
                
                for image in self.carouselImages
                {
                    let dengagePayload1 = DengageRecievedMessage()
                    dengagePayload1.image = image
                    dengagePayload1.title = "test"
                    dengagePayload1.description = "desc"
                    self.payloads.append(dengagePayload1)
                }

                DispatchQueue.main.async {
                    self.dengageCollectionView.reloadData()
                }
                
            } else {
                //handle non localytics rich push
            }
        }
    }
    
    open func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        if response.actionIdentifier == "NEXT_ACTION" {
            self.scrollNextItem()
            completion(UNNotificationContentExtensionResponseOption.doNotDismiss)
        }else if response.actionIdentifier == "PREVIOUS_ACTION" {
            self.scrollPreviousItem()
            completion(UNNotificationContentExtensionResponseOption.doNotDismiss)
        }else {
            completion(UNNotificationContentExtensionResponseOption.dismissAndForwardAction)
        }
    }
    
    //current index'i belirleyip ilgili item'a scroll ettiriyoruz. Sağdan soldan eşit bölünmesi içinde sağ ve sol content inset'lerle oynuyoruz.
    private func scrollNextItem(){
        self.currentIndex == (self.carouselImages.count - 1) ? (self.currentIndex = 0) : ( self.currentIndex += 1 )
        let indexPath = IndexPath(row: self.currentIndex, section: 0)
        self.dengageCollectionView.contentInset.right = (indexPath.row == 0 || indexPath.row == self.carouselImages.count - 1) ? 10.0 : 20.0
        self.dengageCollectionView.contentInset.left = (indexPath.row == 0 || indexPath.row == self.carouselImages.count - 1) ? 10.0 : 20.0
        self.dengageCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.right, animated: true)
    }
    
    private func scrollPreviousItem(){
        self.currentIndex == 0 ? (self.currentIndex = self.carouselImages.count - 1) : ( self.currentIndex -= 1 )
        let indexPath = IndexPath(row: self.currentIndex, section: 0)
        self.dengageCollectionView.contentInset.right = (indexPath.row == 0 || indexPath.row == self.carouselImages.count - 1) ? 10.0 : 20.0
        self.dengageCollectionView.contentInset.left = (indexPath.row == 0 || indexPath.row == self.carouselImages.count - 1) ? 10.0 : 20.0
        self.dengageCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: true)
    }
    
}

extension DengageNotificationViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.payloads.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "CarouselNotificationCell"
        self.dengageCollectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CarouselNotificationCell
        let payloads = self.payloads[indexPath.row]
        cell.configure(imagePath: payloads.image!, title: payloads.title!, desc: payloads.description!)
        cell.layer.cornerRadius = 8.0
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.dengageCollectionView.frame.width
        let cellWidth = (indexPath.row == 0 || indexPath.row == self.carouselImages.count - 1) ? (width - 30) : (width - 40)
        return CGSize(width: cellWidth, height: width - 20.0)
    }
    
}
