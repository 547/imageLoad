//
//  KingfisherExtension.swift
//  imageLoad
//
//  Created by seven on 2018/2/28.
//  Copyright © 2018年 seven. All rights reserved.
//

import Foundation
import Kingfisher
///Kingfisher 默认缓存key就是url

///以下这个方法仅仅只能解决因为服务端的图片过大，导致app这边内存频繁到达临界点已下载的图片被清理，因而图片会多次下载的情况（如果服务端提供的图片过大，这个方法只是辅助性的，但是治标不治本，要在根本上解决问题任需服务端提供缩略图）
/// 换句话说以下的方法仅能在一定程度上解决app上关于图片的内存问题，但并不能解决图片加载速度的问题
extension KingfisherManager {
    @discardableResult
    func retrieveImage(with resource: Resource,
                       imageResize: CGSize?,
                       options: KingfisherOptionsInfo?,
                       progressBlock: DownloadProgressBlock?,
                       completionHandler: CompletionHandler?) -> RetrieveImageTask {
        return retrieveImage(with: resource, options: options, progressBlock: progressBlock) {[weak self] (image, error, cacheType, url) in
            if let resize = imageResize {
                if let img = image {
                    if img.size != resize {
                        let resizedImage = img.kf.resize(to: resize)
                        //替换memory和disk中的大图
                        self?.replaceImageCache(resizedImage, originalImage: img, forKey: resource.cacheKey, toDisk: true, completionHandler: {
                            completionHandler?(resizedImage,error,cacheType,url)
                        })
                    }else{
                        completionHandler?(img,error,cacheType,url)
                    }
                }else{
                    completionHandler?(image,error,cacheType,url)
                }
            }else{
                completionHandler?(image,error,cacheType,url)
            }
        }
    }
}
extension KingfisherManager {
    func replaceImageCache(_ image: Image,
                           originalImage: Image? = nil,
                           forKey key: String,
                           toDisk: Bool = true,
                           completionHandler: (() -> Void)?) -> () {
        let imageCache = ImageCache.default
        let serializer = DefaultCacheSerializer.default
        //替换memory和disk中的大图
        imageCache.store(image, original: originalImage == nil ? nil : UIImagePNGRepresentation(originalImage!), forKey: key, processorIdentifier: "", cacheSerializer: serializer, toDisk: toDisk, completionHandler: {
            completionHandler?()
            print("====缓存图片替换成功====")
        })
    }
}
extension Kingfisher where Base: UIImageView {
    @discardableResult
    public func setImage(with resource: Resource?,
                         imageResize: CGSize?,
                         placeholder: Placeholder? = nil,
                         options: KingfisherOptionsInfo? = nil,
                         progressBlock: DownloadProgressBlock? = nil,
                         completionHandler: CompletionHandler? = nil) -> RetrieveImageTask {
       return setImage(with: resource, placeholder: placeholder, options: options, progressBlock: progressBlock) {[weak base] (image, error, cacheType, url) in
            if let resize = imageResize, let resource = resource {
                if let img = image, let strongBase = base {
                    if img.size != resize {
                        placeholder?.add(to: strongBase)
                        let resizedImage = img.kf.resize(to: resize)
                        //替换memory和disk中的大图
                        KingfisherManager.shared.replaceImageCache(resizedImage, originalImage: img, forKey: resource.cacheKey, toDisk: true, completionHandler: {
                            strongBase.image = resizedImage
                            completionHandler?(resizedImage,error,cacheType,url)
                        })
                    }else{
                        completionHandler?(img,error,cacheType,url)
                    }
                }else{
                    completionHandler?(image,error,cacheType,url)
                }
            }else{
                completionHandler?(image,error,cacheType,url)
            }
        }
    }
}
extension Kingfisher where Base : UIButton {
    @discardableResult
    public func setImage(with resource: Resource?,
                         imageResize: CGSize?,
                         for state: UIControlState,
                         placeholder: UIImage? = nil,
                         options: KingfisherOptionsInfo? = nil,
                         progressBlock: DownloadProgressBlock? = nil,
                         completionHandler: CompletionHandler? = nil) -> RetrieveImageTask{
        return setImage(with: resource, for: state, placeholder: placeholder, options: options, progressBlock: progressBlock) {[weak base] (image, error, cacheType, url) in
            if let resize = imageResize, let resource = resource {
                if let img = image, let strongBase = base {
                    if img.size != resize {
                        strongBase.setImage(placeholder, for: state)
                        let resizedImage = img.kf.resize(to: resize)
                        //替换memory和disk中的大图
                        KingfisherManager.shared.replaceImageCache(resizedImage, originalImage: img, forKey: resource.cacheKey, toDisk: true, completionHandler: {
                            strongBase.setImage(resizedImage, for: state)
                            completionHandler?(resizedImage,error,cacheType,url)
                        })
                    }else{
                        completionHandler?(img,error,cacheType,url)
                    }
                }else{
                    completionHandler?(image,error,cacheType,url)
                }
            }else{
                completionHandler?(image,error,cacheType,url)
            }
        }
    }
    
    @discardableResult
    public func setBackgroundImage(with resource: Resource?,
                                   imageResize: CGSize?,
                                   for state: UIControlState,
                                   placeholder: UIImage? = nil,
                                   options: KingfisherOptionsInfo? = nil,
                                   progressBlock: DownloadProgressBlock? = nil,
                                   completionHandler: CompletionHandler? = nil) -> RetrieveImageTask{
        return setBackgroundImage(with: resource, for: state, placeholder: placeholder, options: options, progressBlock: progressBlock) {[weak base] (image, error, cacheType, url) in
            if let resize = imageResize, let resource = resource {
                if let img = image, let strongBase = base {
                    if img.size != resize {
                        strongBase.setBackgroundImage(placeholder, for: state)
                        let resizedImage = img.kf.resize(to: resize)
                        //替换memory和disk中的大图
                        KingfisherManager.shared.replaceImageCache(resizedImage, originalImage: img, forKey: resource.cacheKey, toDisk: true, completionHandler: {
                            strongBase.setBackgroundImage(resizedImage, for: state)
                            completionHandler?(resizedImage,error,cacheType,url)
                        })
                    }else{
                        completionHandler?(img,error,cacheType,url)
                    }
                }else{
                    completionHandler?(image,error,cacheType,url)
                }
            }else{
                completionHandler?(image,error,cacheType,url)
            }
        }
    }
}
