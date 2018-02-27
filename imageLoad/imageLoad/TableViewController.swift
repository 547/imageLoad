//
//  TableViewController.swift
//  imageLoad
//
//  Created by seven on 2018/2/27.
//  Copyright © 2018年 seven. All rights reserved.
//

import UIKit
import Kingfisher
/***
 按下面这个方法做就是将Kingfisher当成一个图片下载器，还把Kingfisher设计的内存处理都废弃了，虽然看上去好像不用再重新加载被删除的图片，但实则牺牲了很多内存
 **/
class TableViewController: UITableViewController {
    let imageUrls = ["http://pic8.nipic.com/20100801/387600_002750589396_2.jpg",
                     "http://pic40.nipic.com/20140412/11857649_170524977000_2.jpg",
                     "http://pic12.photophoto.cn/20090910/0005018303466977_b.jpg",
                     "http://pic24.photophoto.cn/20120814/0005018348123206_b.jpg",
                     "http://f8.topitme.com/8/25/80/1125177570eea80258o.jpg",
                     "http://pic36.photophoto.cn/20150728/0022005597823716_b.jpg",
                     "http://pic35.photophoto.cn/20150528/0005018358146030_b.jpg",
                     "http://e.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=1a3963408f94a4c20a76ef2f3bc437e3/e4dde71190ef76c66b5e79649516fdfaae5167f5.jpg",
                     "http://pic28.photophoto.cn/20130830/0005018667531249_b.jpg",
                     "http://f9.topitme.com/9/d5/59/112874511432059d59o.jpg",
                     "http://pic28.photophoto.cn/20130827/0005018357738694_b.jpg",
                     "http://img.52z.com/upload/news/image/20180130/20180130085439_69033.jpg",
                     "http://pic.ffpic.com/files/2014/0221/0220dmnhtpsjbz3.jpg",
                     "http://pic.35pic.com/normal/08/41/68/12095453_195255558000_2.jpg",
                     "http://pic.58pic.com/58pic/11/11/21/71T58PICzSB.jpg",
                     "http://pic54.nipic.com/file/20141202/19938643_174717192175_2.jpg"]
    var images = [Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageUrls.forEach {[weak self] (item) in
            self?.images.append(item)
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func refreash(_ sender: Any) {
        tableView.reloadData()
    }
    @IBAction func clear(_ sender: UIBarButtonItem) {
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        print("=====清空完成=====")
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return imageUrls.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row = indexPath.row
        guard let url = URL.init(string: imageUrls[row]) else { return cell }
        
        if images.count > row, let img = images[row] as? UIImage {
            print("=====数组中已有图片====")
            cell.imageView?.image = img
        }else{
            print("=====数组中没有图片====")
            cell.imageView?.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder"), options: nil, progressBlock: nil, completionHandler: {[weak self] (image, _, _, _) in
                if let img = image {
                    print("==\(row)===图片下载成功====")
                    self?.images.remove(at: row)
                    self?.images.insert(img, at: row)
                }else{
                    print("==\(row)===图片下载失败====")
                }
            })
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
